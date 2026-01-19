// =============================================================================
// Event Types - WebSocket Event Envelope Contracts
// =============================================================================
// These types define the event envelope structure for all real-time
// WebSocket messages. All broadcasts MUST use EventEnvelope wrapper.
// =============================================================================

// -----------------------------------------------------------------------------
// Event Type Enum
// -----------------------------------------------------------------------------

/// All WebSocket event types (stable enum, not free-form strings)
enum EventType {
  // State events
  CONTEXT_CHANGED @alias("context_changed")
  STATE_UPDATED @alias("state_updated")

  // Chat/Conversation events
  MESSAGE_RECEIVED @alias("message_received")
  MESSAGE_SENT @alias("message_sent")
  CONVERSATION_STARTED @alias("conversation_started")
  CONVERSATION_ENDED @alias("conversation_ended")

  // Action events
  ACTION_PENDING @alias("action_pending")
  ACTION_EXECUTING @alias("action_executing")
  ACTION_COMPLETED @alias("action_completed")
  ACTION_FAILED @alias("action_failed")
  ACTION_CANCELLED @alias("action_cancelled")

  // Frontend command events
  FRONTEND_COMMAND @alias("frontend_command")
  FRONTEND_COMMAND_RESULT @alias("frontend_command_result")

  // Scheduled message events
  SCHEDULED_MESSAGE_CREATED @alias("scheduled_message_created")
  SCHEDULED_MESSAGE_UPDATED @alias("scheduled_message_updated")
  SCHEDULED_MESSAGE_APPROVED @alias("scheduled_message_approved")
  SCHEDULED_MESSAGE_SENT @alias("scheduled_message_sent")
  SCHEDULED_MESSAGE_CANCELLED @alias("scheduled_message_cancelled")
  SCHEDULED_MESSAGE_FAILED @alias("scheduled_message_failed")
  SCHEDULED_MESSAGE_REVIEW_DUE @alias("scheduled_message_review_due")

  // Command center events
  COMMAND_CENTER_UPDATED @alias("command_center_updated")
  PRIORITY_ITEM_ADDED @alias("priority_item_added")
  PRIORITY_ITEM_COMPLETED @alias("priority_item_completed")

  // Voice learning events
  VOICE_CORRECTION_SUBMITTED @alias("voice_correction_submitted")
  VOICE_PROFILE_UPDATED @alias("voice_profile_updated")

  // Private intelligence events
  OBSERVATION_DETECTED @alias("observation_detected")
  CURRENT_READ_UPDATED @alias("current_read_updated")

  // Resource events
  RESOURCE_CREATED @alias("resource_created")
  RESOURCE_UPDATED @alias("resource_updated")
  RESOURCE_DELETED @alias("resource_deleted")

  // Session events
  SESSION_STARTED @alias("session_started")
  SESSION_UPDATED @alias("session_updated")
  SESSION_ENDED @alias("session_ended")

  // Connection events
  CONNECTION_ESTABLISHED @alias("connection_established")
  CONNECTION_ERROR @alias("connection_error")
  HEARTBEAT @alias("heartbeat")

  // Error events
  ERROR @alias("error")

  // Onboarding events (v1.1.0)
  ONBOARDING_STEP_COMPLETED @alias("onboarding_step_completed")
  ONBOARDING_PHASE_STARTED @alias("onboarding_phase_started")
  VOICE_SAMPLES_SUBMITTED @alias("voice_samples_submitted")

  // T-15 Prep events (v1.1.0)
  T15_PREP_GENERATED @alias("t15_prep_generated")
  T15_PREP_UPDATED @alias("t15_prep_updated")
  T15_PREP_VIEWED @alias("t15_prep_viewed")

  // Session Notes events (v1.1.0)
  SESSION_NOTES_GENERATED @alias("session_notes_generated")
  SESSION_NOTES_UPDATED @alias("session_notes_updated")
  SESSION_NOTES_FINALIZED @alias("session_notes_finalized")
  SESSION_NOTES_SHARED @alias("session_notes_shared")
}

// -----------------------------------------------------------------------------
// Event Metadata
// -----------------------------------------------------------------------------

/// Metadata for every event (required for debugging/replay)
class EventMeta {
  timestamp string  // ISO 8601
  correlationId string?  // Links related events
  contractsVersion string  // Version of contracts package
  actorId int?  // User who triggered event (if applicable)
  requestId string?  // Original HTTP request ID (if applicable)
}

// -----------------------------------------------------------------------------
// Event Envelope (REQUIRED wrapper for all WebSocket messages)
// -----------------------------------------------------------------------------

/// Event envelope - all WebSocket messages MUST be wrapped in this
class EventEnvelope {
  type EventType
  meta EventMeta
  payload map<string, string>  // Flexible payload, validated by type
}

// -----------------------------------------------------------------------------
// Typed Payload Classes
// -----------------------------------------------------------------------------

/// Payload for CONTEXT_CHANGED and STATE_UPDATED events
class ContextChangedPayload {
  page string
  clientId int?
  clientName string?
  sessionId string?
  sessionDate string?
  availableActions string[]
  source string?
}

/// Payload for MESSAGE_RECEIVED and MESSAGE_SENT events
class MessagePayload {
  conversationId string
  role string
  content string
  timestamp string
}

/// Payload for ACTION_* events
class ActionEventPayload {
  actionId string
  tool string
  status string
  parameters map<string, string>
  result map<string, string>?
  error map<string, string>?
}

/// Payload for FRONTEND_COMMAND event
class FrontendCommandPayload {
  actionId string
  tool string
  parameters map<string, string>
  timeout int
  requiresConfirmation bool
}

/// Payload for SCHEDULED_MESSAGE_* events
class ScheduledMessageEventPayload {
  messageId string
  clientId int
  clientName string?
  channel string
  subject string?
  scheduledFor string
  status string
  previousStatus string?
}

/// Payload for COMMAND_CENTER_UPDATED event
class CommandCenterEventPayload {
  focusNowCount int
  soonCount int
  laterCount int
  lastUpdated string
}

/// Payload for PRIORITY_ITEM_* events
class PriorityItemPayload {
  itemId string
  type string
  clientId int
  clientName string?
  priority string
  action string
}

/// Payload for VOICE_* events
class VoiceEventPayload {
  correctionId string?
  voiceConfidence float?
  contentType string?
}

/// Payload for OBSERVATION_DETECTED event
class ObservationPayload {
  observationId string
  clientId int
  type string
  description string
  confidence float
}

/// Payload for RESOURCE_* events
class ResourceEventPayload {
  resourceId string
  clientId int
  type string
  title string
  action string  // created, updated, deleted
}

/// Payload for SESSION_* events
class SessionEventPayload {
  sessionId string
  clientId int
  clientName string?
  status string
  scheduledAt string?
}

/// Payload for ERROR event
class ErrorPayload {
  code string
  message string
  details map<string, string>
  retryable bool
}

/// Payload for CONNECTION_ESTABLISHED event
class ConnectionPayload {
  connectionId string
  userId int
  capabilities string[]
}

/// Payload for HEARTBEAT event
class HeartbeatPayload {
  serverTime string
  connectionAge int  // seconds
}

// -----------------------------------------------------------------------------
// v1.1.0 Typed Payload Classes
// -----------------------------------------------------------------------------

/// Payload for ONBOARDING_* events
class OnboardingEventPayload {
  coachId int
  phase string  // OnboardingPhase value
  previousPhase string?
  overallProgress float  // 0-1
  action string  // started, completed, skipped
  timestamp string  // ISO 8601
}

/// Payload for VOICE_SAMPLES_SUBMITTED event
class VoiceSamplesPayload {
  coachId int
  sampleCount int
  totalSamples int
  sampleTypes string[]  // VoiceSampleType values
  voiceProfileStatus string  // needs_more_samples, ready, training, etc.
}

/// Payload for T15_PREP_* events
class T15PrepEventPayload {
  prepId string
  sessionId int
  clientId int
  clientName string?
  scheduledAt string  // ISO 8601 - session time
  action string  // generated, updated, viewed
  sectionsCompleted int
  totalSections int
  overallReadiness string?
}

/// Payload for SESSION_NOTES_* events
class SessionNotesEventPayload {
  notesId string
  sessionId int
  clientId int
  clientName string?
  sessionDate string  // ISO 8601
  action string  // generated, updated, finalized, shared
  status string  // SessionNotesStatus value
  previousStatus string?
  sectionsCompleted int
  totalSections int
}
