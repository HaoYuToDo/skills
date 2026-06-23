# GitHub Copilot Instructions

Use `AGENTS.md` as the canonical project instruction file. This file exists only to help Copilot discover the shared rules.

When suggesting code or documentation:

- Respect the Vue 3 frontend, NestJS backend, and `packages/shared` contract boundaries described in `AGENTS.md`.
- Prefer links to detailed docs over duplicating rules in this file.
- Do not invent build, test, migration, or deployment commands.
- If a suggestion changes API contracts, include corresponding shared type and test updates.

