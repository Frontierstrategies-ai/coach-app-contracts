// =============================================================================
// Feature Types - AI-Powered Coaching Capabilities
// =============================================================================
// These types support Voice Learning, Command Center, Resource Library,
// AI Command Bar, Communication Transparency, and Private Intelligence features.
// =============================================================================

// -----------------------------------------------------------------------------
// Voice Learning Types
// -----------------------------------------------------------------------------

enum EditType {
  MINOR_TWEAK @alias("minor_tweak")
  SIGNIFICANT_CHANGE @alias("significant_change")
  COMPLETE_REWRITE @alias("complete_rewrite")
}

enum CoachFeedback {
  OFF_VOICE @alias("off_voice")
  PERFECT @alias("perfect")
}

enum VoiceContentType {
  SESSION_NOTES @alias("session_notes")
  EMAIL @alias("email")
  MESSAGE @alias("message")
}

/// A single voice correction record
class VoiceCorrection {
  id string
  originalContent string
  editedContent string
  editType EditType
  coachFeedback CoachFeedback?
  contentType VoiceContentType
  sessionId string?
  timestamp string  // ISO 8601
}

/// Request to submit a voice correction
class VoiceCorrectionRequest {
  sessionId string?
  originalContent string
  editedContent string
  editType EditType
  coachFeedback CoachFeedback?
  contentType VoiceContentType?
}

/// Response from submitting a voice correction
class VoiceCorrectionResponse {
  success bool
  voiceConfidenceAfter float  // 0-1
  improvementNote string?
  correctionId string?
}

/// Tone preference configuration
class TonePreference {
  tone string  // e.g., "warm", "professional", "direct"
  weight float  // 0-1
}

/// Coach's voice profile
class VoiceProfile {
  coachId int
  voiceConfidence float  // 0-1
  totalCorrections int
  vocabularyPatterns string[]
  avoidPatterns string[]
  tonePreferences TonePreference[]
  recentEdits VoiceCorrection[]
  lastTrainedAt string?
}

/// Voice profile configuration (for onboarding setup)
class VoiceProfileConfig {
  coachId int
  minSamplesRequired int  // Minimum writing samples needed
  currentSampleCount int  // Current submitted samples
  sampleTypes VoiceContentType[]  // Types of samples submitted
  trainingStatus VoiceTrainingStatus
  estimatedConfidence float?  // Estimated voice confidence after training
  canStartTraining bool  // Whether enough data to begin training
  lastUpdated string  // ISO 8601
}

/// Status of voice profile training
enum VoiceTrainingStatus {
  NEEDS_SAMPLES @alias("needs_samples")   // Not enough samples yet
  READY @alias("ready")                   // Ready to train
  TRAINING @alias("training")             // Training in progress
  TRAINED @alias("trained")               // Training complete
  RETRAINING @alias("retraining")         // Retraining with new data
}

// Voice Learning v1 Reference
// LLM-based semantic style analysis types are defined in:
// baml_src/types/voice-learning-v1.baml
//
// v1 extends v0 with:
// - ToneVector: 5-dimensional tone profile
// - StyleAnalysis: LLM-computed style characteristics
// - StyleInsight: Human-readable insights for dashboard
// - VoiceProfileV1: Extended profile with style analysis
// - VoiceMatchResult: Detailed scoring results
// - StyleTuning: Manual coach adjustments
// - AnalyzeStyleFromCorrections: BAML function for batch analysis

// -----------------------------------------------------------------------------
// Command Center Types
// -----------------------------------------------------------------------------

enum CommandItemType {
  CLIENT_ACTION @alias("client_action")
  SESSION_PREP @alias("session_prep")
  FOLLOW_UP @alias("follow_up")
  PATTERN_ALERT @alias("pattern_alert")
}

enum Priority {
  FOCUS_NOW @alias("focus_now")
  SOON @alias("soon")
  LATER @alias("later")
}

/// A single command center item
class CommandCenterItem {
  id string
  type CommandItemType
  clientId int
  clientName string?
  priority Priority
  priorityReason string  // AI explains why this is prioritized
  action string  // What to do
  dueDate string?  // ISO 8601
  crossDomainContext string?  // Links to coach's personal goals
  sessionId string?
  createdAt string  // ISO 8601
}

/// Grouped command center response
class CommandCenterData {
  focusNow CommandCenterItem[]
  soon CommandCenterItem[]
  later CommandCenterItem[]
  lastUpdated string  // ISO 8601
}

// -----------------------------------------------------------------------------
// Resource Library Types
// -----------------------------------------------------------------------------

enum ResourceType {
  DOCUMENT @alias("document")
  LINK @alias("link")
  FRAMEWORK @alias("framework")
  TEMPLATE @alias("template")
}

/// Metadata for a resource item
class ResourceMetadata {
  fileSize int?
  mimeType string?
  originalName string?
  linkTitle string?
  linkDescription string?
  linkImage string?
}

/// A single resource item
class ResourceItem {
  id string
  clientId int
  coachId int
  type ResourceType
  title string
  description string?
  fileUrl string?  // For documents (presigned S3 URL)
  externalUrl string?  // For links
  thumbnailUrl string?
  tags string[]
  metadata ResourceMetadata
  createdAt string  // ISO 8601
  updatedAt string  // ISO 8601
}

/// Request to create a new resource
class CreateResourceRequest {
  type ResourceType
  title string
  description string?
  externalUrl string?  // For links
  tags string[]
}

/// Request to update an existing resource
class UpdateResourceRequest {
  title string?
  description string?
  tags string[]
  externalUrl string?
}

/// Paginated resource list
class ResourceListData {
  items ResourceItem[]
  total int
  page int
  pageSize int
  nextPage int?
}

// -----------------------------------------------------------------------------
// AI Command Bar Types
// -----------------------------------------------------------------------------

enum AICommandType {
  TONE_ADJUSTMENT @alias("tone_adjustment")
  CONTENT_ADDITION @alias("content_addition")
  CONTENT_REMOVAL @alias("content_removal")
  SECTION_MODIFICATION @alias("section_modification")
  VOICE_CORRECTION @alias("voice_correction")
  SPECIFIC_EDIT @alias("specific_edit")
}

/// Request to execute an AI command
class AICommandRequest {
  contentId string  // Session UUID or content identifier
  section string?  // Specific section to modify
  command string  // Natural language command
  currentContent string  // The content to modify
  commandType AICommandType?  // Optional hint
}

/// Response from executing an AI command
class AICommandResult {
  editedContent string
  explanation string?
  appliedChange string?  // Summary of what changed
  commandId string?  // For undo/tracking
}

/// A single AI command history entry
class AICommandHistoryItem {
  id string
  command string
  commandType AICommandType?
  originalContent string
  editedContent string
  section string?
  applied bool
  explanation string?
  createdAt string  // ISO 8601
}

// -----------------------------------------------------------------------------
// Communication Transparency Types
// -----------------------------------------------------------------------------

enum TransparencyIndicator {
  COACH_DIRECT @alias("coach_direct")              // Coach wrote directly
  AI_DRAFTED_APPROVED @alias("ai_drafted_approved") // AI draft, coach approved
  AI_AUTONOMOUS @alias("ai_autonomous")             // AI only (pre-approved types)
}

/// Message with transparency metadata
class TransparentMessage {
  content string
  indicator TransparencyIndicator
  coachName string?
  approvedAt string?  // ISO 8601
}

// -----------------------------------------------------------------------------
// Private Intelligence Layer Types
// -----------------------------------------------------------------------------

enum ObservationType {
  PATTERN @alias("pattern")
  CHANGE @alias("change")
  BREAKTHROUGH @alias("breakthrough")
}

/// AI's current read/assessment of client
class CurrentRead {
  assessment string
  confidence float  // 0-1
  lastUpdated string  // ISO 8601
}

/// A single observation entry
class ObservationEntry {
  id string
  type ObservationType
  description string
  evidence string[]  // Quote excerpts
  confidence float  // 0-1
  detectedAt string  // ISO 8601
  dismissed bool
  dismissedBy string?
  dismissedAt string?
}

/// Complete private intelligence for a client
class PrivateIntelligence {
  clientId int
  currentRead CurrentRead?
  observations ObservationEntry[]
  coachPrivateNotes string?
  lastUpdated string  // ISO 8601
}
