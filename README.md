# coach-app-contracts

[![PyPI version](https://badge.fury.io/py/coach-app-baml-client.svg)](https://pypi.org/project/coach-app-baml-client/)
[![npm version](https://badge.fury.io/js/coach-app-baml-client.svg)](https://www.npmjs.com/package/coach-app-baml-client)

Boundary contracts and generated SDKs for the Coach App ecosystem.

## What is this?

A dedicated contracts repository that serves as the **single source of truth** for:

- **Boundary BAML schemas** - shared DTO types that cross the frontend/backend boundary
- **Real-time event envelopes** - WebSocket event types and payload DTOs
- **Generated SDKs** - versioned Python (Pydantic) and TypeScript packages

This keeps frontend and backend boundary models synchronized without requiring a monorepo.

## Installation

### Python (Backend)

```bash
pip install coach-app-baml-client
```

Requires Python >= 3.10 and installs `pydantic` and `baml-py` as dependencies.

### TypeScript (Frontend)

```bash
npm install coach-app-baml-client
```

Requires Node.js >= 18.0.0 and `@boundaryml/baml` as a peer dependency.

## Quick Start

### Python

```python
from coach_app_baml_client import (
    ChatRequest,
    ChatResponse,
    PageContext,
    EventEnvelope,
    EventType,
)

# Create a chat request
request = ChatRequest(
    message="How should I prepare for my next session?",
    context=PageContext(
        url="https://app.example.com/clients/123",
        route="/clients/:id",
        clientId=123,
        pageData={},
    ),
)

# Handle a WebSocket event
def handle_event(envelope: EventEnvelope):
    if envelope.type == EventType.CONTEXT_CHANGED:
        print(f"Context changed at {envelope.meta.timestamp}")
```

### TypeScript

```typescript
import type {
  ChatRequest,
  ChatResponse,
  PageContext,
  EventEnvelope,
  EventType,
} from 'coach-app-baml-client';

// Type-safe request
const request: ChatRequest = {
  message: 'How should I prepare for my next session?',
  context: {
    url: 'https://app.example.com/clients/123',
    route: '/clients/:id',
    clientId: 123,
    pageData: {},
  },
};

// Handle WebSocket events with type safety
function handleEvent(envelope: EventEnvelope) {
  if (envelope.type === 'context_changed') {
    console.log(`Context changed at ${envelope.meta.timestamp}`);
  }
}
```

## Type Categories

### Core Types

Request/response contracts for chat and action execution:

- `ChatRequest`, `ChatResponse` - Chat conversation contracts
- `ActionRequest`, `ActionResponse` - Tool execution contracts
- `PageContext`, `ResolvedContext` - Browser context types
- `ChatMessage`, `SuggestedAction` - Supporting types
- `FrontendCommand`, `FrontendActionResult` - Bidirectional command types

### Event Types

WebSocket event system with 50 event types:

- `EventEnvelope` - Required wrapper for all WebSocket messages
- `EventType` - Enum of all event types (state, chat, action, session, etc.)
- `EventMeta` - Metadata for debugging/replay (timestamp, correlationId, contractsVersion)
- Typed payloads: `ContextChangedPayload`, `MessagePayload`, `ActionEventPayload`, etc.

### Dashboard Types

Coach dashboard data contracts:

- `SessionPrepStatus` - Session preparation status
- `RecentClient` - Recent client summary
- `DashboardData` - Full dashboard response
- `DashboardPreferences`, `DashboardSection` - Layout configuration

### T-15 Prep Types

Pre-session preparation documents with 9 typed sections:

- `PrepDocument` - Full prep document structure
- `NorthStarReminder`, `LastSessionRecap`, `Commitment` - Section types
- `LifeContextItem`, `PatternIntelligence`, `SuggestedOpener` - Intelligence types
- `PrepTemplate`, `PrepResponse`, `PrepSummary` - Supporting types

### Session Notes Types

Post-session documentation:

- `SessionNotesDocument` - Full notes structure
- `SessionSummary`, `ClientProgress`, `ActionItem` - Section types
- `SessionNotesStatus` - Document lifecycle status

### Messaging Types

Scheduled messaging contracts:

- `ScheduledMessage`, `ScheduledMessageStatus`
- `MessageTemplate`, `MessageChannel`

### State Types

User active state management:

- `UserActiveState` - Current user state (broadcast via WebSocket)
- `StateUpdateRequest`, `StateUpdateResponse` - State change contracts
- `NavigationOption`, `StateSource` - Supporting types

### Additional Types

- **Onboarding**: `OnboardingStatus`, `OnboardingPhase`, `OnboardingStepStatus`
- **Voice Learning**: `VoiceSample`, `VoiceSampleType`, `VoiceCorrection`
- **Client Profile**: `ClientProfile`, `ClientGoal`, `GoalStatus`
- **UI Patterns**: `UIComponentState`, `ExpandableSection`, `FormFieldState`
- **Features**: `FeatureFlag`, `FeatureContext`

## Development

### Prerequisites

- Node.js 20+
- Python 3.10+
- BAML CLI (`npm install -g @boundaryml/baml`)

### Generate SDKs

```bash
# Validate schemas
baml-cli check

# Generate Python and TypeScript code
baml-cli generate
```

### Build Packages

```bash
# TypeScript
cd packages/typescript
npm install
npm run build

# Python
cd packages/python
pip install build
python -m build
```

### Local Testing

```bash
# Link TypeScript package locally
cd packages/typescript
npm link

# In your frontend project
npm link coach-app-baml-client
```

## Versioning

This repository follows **SemVer** with a single version for both packages:

- **PATCH** - Prompt tweaks, tests, metadata-only changes
- **MINOR** - Additive, backward-compatible type changes
- **MAJOR** - Breaking schema or function changes

Both Python and TypeScript packages are **released together** with the same version number.

Current version: **2.1.0**

## Architecture

This repo implements a **boundary contracts pattern**:

```
┌─────────────────────┐     ┌─────────────────────┐
│  coach-app-frontend │     │  coach-app-backend  │
│     (TypeScript)    │     │      (Django)       │
└─────────┬───────────┘     └──────────┬──────────┘
          │                            │
          │    imports generated       │
          │    types & client          │
          │                            │
          └──────────┬─────────────────┘
                     │
          ┌──────────▼──────────┐
          │ coach-app-contracts │
          │  (this repository)  │
          │                     │
          │  baml_src/*.baml    │
          │         ↓           │
          │  Generated SDKs     │
          │  - Python/Pydantic  │
          │  - TypeScript       │
          └─────────────────────┘
```

### What belongs here

- Shared DTO types that cross the frontend/backend boundary
- Real-time event envelopes and payload DTOs
- Shared enums used across repos

### What does NOT belong here

- Django ORM models or migrations
- Frontend UI state or components
- Backend-only or frontend-only types

### Non-negotiable rules

1. No hand edits in generated directories
2. All boundary contract changes require a version bump
3. Both packages are released together
4. Consumers only update dependency versions

## CI/CD

Releases are triggered by version tags (`v*`):

1. Validates BAML schemas
2. Generates SDKs
3. Builds both packages
4. Publishes to PyPI and npm (using OIDC Trusted Publishers)
5. Creates GitHub release with artifacts

## License

MIT
