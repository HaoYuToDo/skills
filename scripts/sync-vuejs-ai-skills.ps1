param(
    [string]$UpstreamUrl = "https://github.com/vuejs-ai/skills.git",
    [string]$Branch = "main",
    [string]$GitSha = "",
    [switch]$Check,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Get-RepoRoot {
    $root = git rev-parse --show-toplevel
    if (-not $root) {
        throw "This script must be run inside a git repository."
    }
    return $root.Trim()
}

function Get-RemoteSha {
    param([string]$Url, [string]$RemoteBranch)

    $line = git ls-remote $Url "refs/heads/$RemoteBranch"
    if (-not $line) {
        throw "Could not resolve $Url branch $RemoteBranch."
    }
    return ($line -split "\s+")[0]
}

function New-TempClone {
    param([string]$Url, [string]$RemoteBranch, [string]$Sha)

    $tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("vuejs-ai-skills-" + [guid]::NewGuid().ToString("N"))
    git clone --depth 1 --branch $RemoteBranch $Url $tempRoot | Out-Host
    Push-Location $tempRoot
    try {
        git fetch --depth 1 origin $Sha | Out-Host
        git checkout --detach $Sha | Out-Host
    }
    finally {
        Pop-Location
    }
    return $tempRoot
}

function Get-RelativeFiles {
    param([string]$Root, [string[]]$ExcludeRelativePaths = @())

    if (-not (Test-Path -LiteralPath $Root)) {
        return @()
    }

    $exclude = @{}
    foreach ($path in $ExcludeRelativePaths) {
        $exclude[$path.Replace("/", "\")] = $true
    }

    return Get-ChildItem -LiteralPath $Root -Recurse -File |
        ForEach-Object { $_.FullName.Substring($Root.Length + 1) } |
        Where-Object { -not $exclude.ContainsKey($_) } |
        Sort-Object
}

function Assert-DirectoriesMatch {
    param(
        [string]$ExpectedRoot,
        [string]$ActualRoot,
        [string[]]$ExcludeActualRelativePaths = @()
    )

    $expectedFiles = @(Get-RelativeFiles -Root $ExpectedRoot)
    $actualFiles = @(Get-RelativeFiles -Root $ActualRoot -ExcludeRelativePaths $ExcludeActualRelativePaths)

    $missing = Compare-Object -ReferenceObject $expectedFiles -DifferenceObject $actualFiles |
        Where-Object { $_.SideIndicator -eq "<=" } |
        Select-Object -ExpandProperty InputObject
    $extra = Compare-Object -ReferenceObject $expectedFiles -DifferenceObject $actualFiles |
        Where-Object { $_.SideIndicator -eq "=>" } |
        Select-Object -ExpandProperty InputObject

    if ($missing) {
        throw "Missing files in $ActualRoot`: $($missing -join ', ')"
    }
    if ($extra) {
        throw "Extra files in $ActualRoot`: $($extra -join ', ')"
    }

    foreach ($relative in $expectedFiles) {
        $expectedFile = Join-Path $ExpectedRoot $relative
        $actualFile = Join-Path $ActualRoot $relative
        $expectedHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $expectedFile).Hash
        $actualHash = (Get-FileHash -Algorithm SHA256 -LiteralPath $actualFile).Hash
        if ($expectedHash -ne $actualHash) {
            throw "File differs: $actualFile"
        }
    }
}

function Write-SyncInfo {
    param([string]$SkillRoot, [string]$SkillName, [string]$Sha)

    $syncedDate = (Get-Date -Format "yyyy-MM-dd")
    $content = @(
        "# Sync Info",
        "",
        "- **Source:** ``vendor/vuejs-ai/skills/$SkillName``",
        "- **Git SHA:** ``$Sha``",
        "- **Synced:** $syncedDate"
    )
    Set-Content -LiteralPath (Join-Path $SkillRoot "SYNC.md") -Value $content -Encoding UTF8
}

$repoRoot = Get-RepoRoot
$resolvedSha = if ($GitSha) { $GitSha } else { Get-RemoteSha -Url $UpstreamUrl -RemoteBranch $Branch }
$vendorRoot = Join-Path $repoRoot "vendor\vuejs-ai\skills"
$activeRoot = Join-Path $repoRoot "skills"

Write-Host "Upstream: $UpstreamUrl"
Write-Host "Branch:   $Branch"
Write-Host "Git SHA:  $resolvedSha"

$tempClone = New-TempClone -Url $UpstreamUrl -RemoteBranch $Branch -Sha $resolvedSha
try {
    $upstreamSkillsRoot = Join-Path $tempClone "skills"
    $skillDirs = @(Get-ChildItem -LiteralPath $upstreamSkillsRoot -Directory | Sort-Object Name)

    if ($Check) {
        foreach ($skillDir in $skillDirs) {
            $name = $skillDir.Name
            $vendorSkill = Join-Path $vendorRoot $name
            $activeSkill = Join-Path $activeRoot $name
            $syncFile = Join-Path $activeSkill "SYNC.md"

            if (-not (Test-Path -LiteralPath $vendorSkill)) {
                throw "Missing vendored skill: $vendorSkill"
            }
            if (-not (Test-Path -LiteralPath $activeSkill)) {
                throw "Missing active skill: $activeSkill"
            }
            if (-not (Test-Path -LiteralPath (Join-Path $activeSkill "SKILL.md"))) {
                throw "Missing SKILL.md in active skill: $activeSkill"
            }
            if (-not (Test-Path -LiteralPath $syncFile)) {
                throw "Missing SYNC.md in active skill: $activeSkill"
            }

            Assert-DirectoriesMatch -ExpectedRoot $skillDir.FullName -ActualRoot $vendorSkill
            Assert-DirectoriesMatch -ExpectedRoot $vendorSkill -ActualRoot $activeSkill -ExcludeActualRelativePaths @("SYNC.md")

            $syncText = Get-Content -Raw -Encoding UTF8 -LiteralPath $syncFile
            $expectedSource = "- **Source:** ``vendor/vuejs-ai/skills/$name``"
            $expectedSha = "- **Git SHA:** ``$resolvedSha``"
            if ($syncText -notmatch [regex]::Escape($expectedSource)) {
                throw "SYNC.md source mismatch: $syncFile"
            }
            if ($syncText -notmatch [regex]::Escape($expectedSha)) {
                throw "SYNC.md Git SHA mismatch: $syncFile"
            }
        }
        Write-Host "Check passed for $($skillDirs.Count) vuejs-ai skills."
        return
    }

    foreach ($skillDir in $skillDirs) {
        $name = $skillDir.Name
        $vendorSkill = Join-Path $vendorRoot $name
        $activeSkill = Join-Path $activeRoot $name

        Write-Host "Syncing $name"

        if ($DryRun) {
            Write-Host "  Would mirror to $vendorSkill"
            Write-Host "  Would mirror to $activeSkill"
            continue
        }

        New-Item -ItemType Directory -Force -Path $vendorRoot, $activeRoot | Out-Null

        if (Test-Path -LiteralPath $vendorSkill) {
            Remove-Item -LiteralPath $vendorSkill -Recurse -Force
        }
        if (Test-Path -LiteralPath $activeSkill) {
            Remove-Item -LiteralPath $activeSkill -Recurse -Force
        }

        Copy-Item -LiteralPath $skillDir.FullName -Destination $vendorSkill -Recurse
        Copy-Item -LiteralPath $vendorSkill -Destination $activeSkill -Recurse
        Write-SyncInfo -SkillRoot $activeSkill -SkillName $name -Sha $resolvedSha
    }

    if ($DryRun) {
        Write-Host "Dry run completed. No files were changed."
    }
    else {
        Write-Host "Synced $($skillDirs.Count) vuejs-ai skills."
    }
}
finally {
    if (Test-Path -LiteralPath $tempClone) {
        Remove-Item -LiteralPath $tempClone -Recurse -Force
    }
}
