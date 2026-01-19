# coach-app-contracts (BAML contracts + generated SDKs)

## What this repo is

A dedicated **contracts repository** that serves as the **single source of truth** for:

1) **Boundary BAML schemas** (`baml_src/**/*.baml`) covering:
   - shared DTO types that cross the frontend/backend boundary
   - real-time event envelope types + event payload DTOs
   - shared enums used across repos
   - any shared/public BAML function signatures whose typed I/O is part of the boundary contract
2) **Generated, versioned SDKs** for:
   - **Python** (Pydantic models + `baml_client`) consumed by `coach-app-backend` (Django)
   - **TypeScript** (TS types + `baml_client`) consumed by `coach-app-frontend`

This repository keeps frontend and backend boundary models synchronized **without requiring a monorepo**.

---

## High-level approach

- This repo owns **boundary** `.baml` source files (shared types + envelopes + any shared/public function signatures)
- Repo-local BAML may exist in `coach-app-backend` / `coach-app-frontend` for implementation-only functions and types that do not cross the boundary
- This repo runs BAML code generation for the boundary schemas it owns
- This repo publishes **language-specific packages**
- Application repos **only consume published packages**
- No application repo ever runs `baml-cli generate` for boundary contracts

---

## Ownership and boundaries

### This repo owns
- `baml_src/**` (canonical boundary source)
- BAML generators configuration
- Generated SDK packaging (Python + TypeScript)
- CI pipelines for validation and release

### This repo does NOT own
- Django ORM models
- Django serializers or views
- Front-end UI state or components
- Runtime secrets or environment configuration
- Backend-only or frontend-only BAML functions/types that do not cross the boundary

---

## BAML ownership policy (shared vs repo-local)

This repo is the source of truth for **boundary contracts** only.

### What belongs in `coach-app-contracts`
- Shared DTO types that cross the frontend/backend boundary
- Real-time event envelope types and event payload DTOs
- Shared enums used across repos
- Only those BAML functions whose **inputs/outputs are part of the public boundary contract**
  (i.e., multiple repos/components must understand the exact function signature or its typed outputs)

### What belongs in `coach-app-backend`
- Backend-only BAML functions (prompt logic, tool-using flows, internal agents)
- Backend-only BAML types that never cross the frontend/backend boundary
- Mapping between contracts and persistence (Django models/migrations)

### What belongs in `coach-app-frontend`
- Frontend-only BAML functions (only if the frontend directly calls LLMs, which should be the exception)
- Frontend-only types that never cross the boundary

### Non-negotiable rule
If a type or payload crosses the boundary (HTTP or real-time), it must be defined here and versioned here.
Repo-local BAML may exist, but it must map into these boundary DTOs before crossing the boundary.

---

## Repository layout

coach-app-contracts/
- baml_src/
  - generators.baml
  - types/
    - *.baml
  - functions/
    - *.baml         (ONLY shared/public boundary functions; omit if none)
  - tests/
    - *.baml
- packages/
  - python/
    - pyproject.toml
    - README.md
    - src/
      - coach_app_baml_client/
        - __init__.py
        - baml_client/   (GENERATED - gitignored)
  - typescript/
    - package.json
    - tsconfig.json
    - README.md
    - src/
      - index.ts        (re-exports only)
      - baml_client/    (GENERATED - gitignored)
- .github/
  - workflows/
    - ci.yml
    - release.yml
- .gitignore

---

## Naming and versioning

### Repository name
coach-app-contracts

### Published packages
- Python: coach-app-baml-client
- TypeScript: @<scope>/coach-app-baml-client

### Versioning rules (SemVer)

A single SemVer version applies to both packages.

- PATCH - prompt tweaks, tests, metadata-only changes
- MINOR - additive, backward-compatible type changes
- MAJOR - breaking schema or function changes

Both packages are released together with the same version number.

---

## Tooling

- Node.js (BAML CLI + TypeScript build)
- Python >= 3.10 (wheel/sdist build)
- BAML runtime versions must be pinned and aligned across generators

---

## BAML generators configuration

Location: baml_src/generators.baml

Key rules:
- output_dir is relative to baml_src/
- Generated output is written directly into package source trees
- Generated code is never hand-edited

Example intent (pseudo-structure, not fenced):

- Python generator
  - output_type: python/pydantic
  - output_dir: ../packages/python/src/coach_app_baml_client
  - version: pinned

- TypeScript generator
  - output_type: typescript
  - output_dir: ../packages/typescript/src
  - module_format: esm
  - version: pinned

---

## Git ignore rules (required)

- Ignore all generated BAML output
- Ignore Python build artifacts
- Ignore Node build artifacts

Generated code may be committed later only by policy, never manually.
Default: generated code is not committed; it is produced during package build in CI.

---

## Type and schema design rules

- BAML types represent boundary DTO-style contracts only
- Avoid Django- or UI-specific concepts
- Prefer additive evolution (optional fields first)
- Use aliases instead of renames where possible
- Treat BAML as an LLM contract layer, not an ORM

---

## Local development workflow

1) Validate contracts
   Run BAML tests from repo root

2) Generate SDKs
   Generate all language targets in one command

3) Build packages
   - Build TypeScript package
   - Build Python wheel/sdist

Application repos never perform these steps for boundary contracts.

---

## Consumption model

### Backend (Django)
- Depends on coach-app-baml-client
- Imports generated Pydantic models and (if applicable) shared/public client functions

### Frontend (TypeScript)
- Depends on @<scope>/coach-app-baml-client
- Uses import type for types when possible
- Should not depend on BAML runtime behavior unless the frontend truly calls LLMs directly

---

## Real-time data flow and broadcast contract policy

This system uses a one-way flow:

Frontend -> Backend -> Database -> Backend broadcasts -> Frontend

### Key rules

- The database never "speaks" contracts directly. Only the backend reads/writes the database.
- The backend is the adapter that:
  - validates inbound frontend payloads against contract DTOs
  - maps DTOs to persistence (Django models / migrations)
  - maps persistence back to DTOs
  - broadcasts validated contract DTOs back to the frontend

### Broadcasts must use event envelopes (not raw DTOs)

All real-time messages (WebSocket/SSE/etc.) MUST be wrapped in an event envelope defined in contracts, rather than sending raw objects.

Recommended envelope fields:

- type (string enum): stable event name (e.g., SESSION_UPDATED, MESSAGE_ADDED)
- schema_version or contracts_version (string): version for safe evolution
- payload (generic): the actual DTO (e.g., SessionSummary)
- meta (object): timestamp, correlation_id, actor_id, request_id, etc.
- type MUST be an enum in contracts, not free-form strings.

This prevents drift, enables backwards compatibility, and supports debugging/replay.

### Compatibility rules (broadcast-safe evolution)

- Additive changes must be backwards compatible:
  - add new fields as optional before making them required
  - add new event types rather than changing semantics of existing types
- Breaking changes require a major contract version bump and coordinated rollout.
- The backend MUST be capable of emitting a contract version that older clients can still decode during rollout windows.

### Validation requirement (non-negotiable)

Before broadcasting any event, the backend MUST validate the outbound message against the generated contract model for that event envelope + payload.

### What to avoid

- Direct DB -> frontend broadcast mechanisms that bypass the backend contract boundary.
- "Implicit" event shapes defined only in application code without a corresponding contract type.

---

## Persistence and database schema policy (Postgres/Django)

- The BAML contracts in this repo define boundary DTOs (LLM I/O + shared types), not the database schema.
- The database schema is owned by coach-app-backend (Django models + migrations).
- Backend code MUST implement an explicit mapping layer:
  - Contract (generated Pydantic/TS types) <-> Django models <-> Postgres
- Contract releases do not create DB migrations automatically.
  - If a contract change requires persistence changes, the backend repo must add Django migrations.
- If storing LLM-derived structured results, prefer:
  - raw_output (text) + parsed_output (jsonb) + contracts_version (text)
  - Validate parsed_output using generated Pydantic models at write/read boundaries.

---

## CI requirements

### Pull request checks
- Run BAML tests
- Run generation
- Build both packages
- Fail if generation or build diverges

### Release pipeline
- Triggered by version tag
- Generates SDKs once
- Publishes Python and TypeScript packages together
- Fails atomically if either publish fails

---

## Forward-looking constraints (designed-in now)

- Contract repo remains authoritative for boundary DTOs and envelopes
- App repos never fork or regenerate boundary contracts
- LLM boundary contracts remain separate from HTTP/OpenAPI contracts
- Breaking changes require explicit major version bumps

---

## Non-negotiable rules

1) No hand edits in generated directories
2) All boundary contract changes require a version bump
3) Python and TypeScript packages are released together
4) Consumers only update dependency versions
