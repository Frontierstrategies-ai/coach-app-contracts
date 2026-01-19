// =============================================================================
// Messaging Types - Scheduled Message Delivery Contracts
// =============================================================================
// These types define the API contracts for scheduled messaging features,
// including message creation, updates, delivery status, and preferences.
// =============================================================================

// -----------------------------------------------------------------------------
// Channel and Status Enums
// -----------------------------------------------------------------------------

/// Channel choices for message delivery
enum MessageChannel {
  EMAIL @alias("email")
  SMS @alias("sms")
  WHATSAPP @alias("whatsapp")
}

/// Status choices for scheduled messages
enum MessageStatus {
  DRAFT @alias("draft")
  APPROVED @alias("approved")
  PENDING_REVIEW @alias("pending_review")
  SENT @alias("sent")
  CANCELLED @alias("cancelled")
  FAILED @alias("failed")
}

// -----------------------------------------------------------------------------
// Scheduled Message Types
// -----------------------------------------------------------------------------

/// Full representation of a scheduled message (API response)
class ScheduledMessage {
  id string
  coachId int
  coachName string
  clientId int
  clientName string
  clientEmail string
  sessionId string?
  sessionDate string?  // ISO 8601
  templateUsed string?
  channel MessageChannel
  subject string?
  body string
  scheduledFor string  // ISO 8601
  aiSuggestedTime string?  // ISO 8601
  aiSuggestionReason string?
  status MessageStatus
  approvedAt string?  // ISO 8601
  reviewedAt string?  // ISO 8601
  sentAt string?  // ISO 8601
  cancelledAt string?  // ISO 8601
  cancellationReason string?
  deliveryAttempts int
  lastDeliveryError string?
  externalMessageId string?
  transparencyIndicator string
  transparencyDisplayName string?
  canEdit bool
  canCancel bool
  canSend bool
  createdAt string  // ISO 8601
  updatedAt string  // ISO 8601
}

/// Request to create a scheduled message
class CreateScheduledMessageRequest {
  clientId int
  sessionId string?
  templateId string?
  channel MessageChannel
  subject string?  // Required for email
  body string
  scheduledFor string  // ISO 8601, must be in future
  useAiSuggestion bool
  autoApprove bool
  transparencyIndicator string?
  transparencyDisplayName string?
}

/// Request to update a scheduled message
class UpdateScheduledMessageRequest {
  subject string?
  body string?
  scheduledFor string?  // ISO 8601
  channel MessageChannel?
}

// -----------------------------------------------------------------------------
// Preferences Types
// -----------------------------------------------------------------------------

/// User preferences for scheduled message handling
class ScheduledMessagePreferences {
  preSendReviewEnabled bool
  preSendReviewMinutes int  // 1-1440 (24 hours max)
  autoCancelIfClientResponds bool
  defaultChannel MessageChannel
  createdAt string  // ISO 8601
  updatedAt string  // ISO 8601
}

/// Request to update preferences
class UpdatePreferencesRequest {
  preSendReviewEnabled bool?
  preSendReviewMinutes int?
  autoCancelIfClientResponds bool?
  defaultChannel MessageChannel?
}

// -----------------------------------------------------------------------------
// AI Timing Suggestion Types
// -----------------------------------------------------------------------------

/// Response from AI timing suggestion
class AiTimingSuggestion {
  suggestedTime string  // ISO 8601
  reason string
  confidence float  // 0-1
  alternativeTimes string[]  // ISO 8601 array
}

/// Request for AI timing suggestion
class AiTimingSuggestionRequest {
  clientId int
  messageType string
  preferredTimeRange string?  // e.g., "morning", "afternoon", "evening"
}

// -----------------------------------------------------------------------------
// Audit Log Types
// -----------------------------------------------------------------------------

/// Audit log entry for message state changes
class ScheduledMessageAuditEntry {
  id string
  messageId string
  action string
  actorId int?
  actorName string?
  details map<string, string>
  createdAt string  // ISO 8601
}

// -----------------------------------------------------------------------------
// List/Pagination Types
// -----------------------------------------------------------------------------

/// Paginated list of scheduled messages
class ScheduledMessageList {
  items ScheduledMessage[]
  total int
  page int
  pageSize int
  hasNext bool
}

/// Filter parameters for listing messages
class ScheduledMessageFilter {
  status MessageStatus?
  channel MessageChannel?
  clientId int?
  sessionId string?
  fromDate string?  // ISO 8601
  toDate string?  // ISO 8601
}
