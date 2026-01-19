# @coach-app/baml-client

BAML-generated TypeScript types and client for coach-app boundary contracts.

## Installation

```bash
npm install @coach-app/baml-client
# or
pnpm add @coach-app/baml-client
# or
yarn add @coach-app/baml-client
```

## Usage

```typescript
import type {
  ChatRequest,
  ChatResponse,
  EventEnvelope,
  EventType,
  MessageRole,
  ScheduledMessage,
  MessageStatus,
} from '@coach-app/baml-client';

// Create a chat request
const request: ChatRequest = {
  message: 'Hello',
  conversationId: 'conv-123',
  conversationHistory: [],
};

// Type-safe event handling
function handleEvent(envelope: EventEnvelope) {
  switch (envelope.type) {
    case 'message_received':
      console.log('Message:', envelope.payload);
      break;
    case 'state_updated':
      console.log('State changed:', envelope.payload);
      break;
  }
}
```

## Type-Only Imports

For frontend code that doesn't need runtime BAML behavior, use type-only imports:

```typescript
import type { ChatRequest, EventEnvelope } from '@coach-app/baml-client';
```

## Generated Code

The `src/baml_client/` directory contains BAML-generated code. Do not edit these files directly.

To regenerate:

```bash
# From repo root
baml-cli generate
```

## Version

This package version corresponds to the contracts version. Both Python and TypeScript packages are released together with the same version number.
