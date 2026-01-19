/**
 * Coach App BAML Client - Generated Types and Client
 *
 * This package provides BAML-generated TypeScript types and client code
 * for coach-app boundary contracts. Types are generated from BAML source
 * files and should not be manually edited.
 *
 * @example
 * ```typescript
 * import type {
 *   ChatRequest,
 *   ChatResponse,
 *   EventEnvelope,
 *   EventType,
 *   MessageRole,
 * } from 'coach-app-baml-client';
 * ```
 *
 * The baml_client subdirectory contains the generated BAML client code.
 */

export const VERSION = '1.1.2';

// Re-export all types from generated baml_client
// This export will be available after BAML generation
export * from './baml_client';

// Type alias for frontend compatibility
// Frontend uses CurrentStateResponse, contracts defines it as UserActiveState
import type { UserActiveState } from './baml_client';
export type CurrentStateResponse = UserActiveState;
