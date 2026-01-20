// =============================================================================
// T-15 Prep Document Types (Typed Structure)
// =============================================================================
// Pre-session preparation document with 9 typed sections.
// Breaking change in v2.0.0: Replaced generic T15SectionContent[] with
// explicitly typed section fields as required by backend spec.
// =============================================================================

// -----------------------------------------------------------------------------
// PrepDocument - Main Document Structure
// -----------------------------------------------------------------------------

/// Full T-15 prep document with typed sections
class PrepDocument {
  id string
  sessionId string
  clientId int
  clientName string
  sessionTitle string
  sessionDateTime string  // ISO 8601

  // 9 Typed Sections
  northStarReminder NorthStarReminder
  lastSessionRecap LastSessionRecap
  commitments Commitment[]
  lifeContext LifeContextItem[]
  patternIntelligence PatternIntelligence[]
  suggestedOpeners SuggestedOpener[]
  privateCoachNotes string
  betweenSessionIntelligence BetweenSessionEvent[]
  coacheePreSessionInput CoacheePreSessionInput

  generatedAt string  // ISO 8601
  status PrepStatus
}

/// Status of prep document
enum PrepStatus {
  DRAFT @alias("draft")
  READY @alias("ready")
  VIEWED @alias("viewed")
}

// -----------------------------------------------------------------------------
// Section Types
// -----------------------------------------------------------------------------

/// Client's articulated purpose and direction
class NorthStarReminder {
  values string[]
  vision string
  overarchingGoals string[]
}

/// Recap of previous session
class LastSessionRecap {
  themes string[]
  breakthroughs string[]
  emotionalMoments string[]
  summary string
  sessionDate string  // ISO 8601
}

/// A commitment from a previous session
class Commitment {
  id string
  description string
  status CommitmentStatus
  source CommitmentSource
  sessionId string?
  createdAt string  // ISO 8601
}

/// Status of a commitment
enum CommitmentStatus {
  COMPLETED @alias("completed")
  PENDING @alias("pending")
  PARTIAL @alias("partial")
  UNKNOWN @alias("unknown")
}

/// Source of a commitment
enum CommitmentSource {
  SESSION @alias("session")
  BETWEEN_SESSION @alias("between_session")
}

/// Recent life context item
class LifeContextItem {
  area LifeContextArea
  summary string
  source string
  updatedAt string  // ISO 8601
}

/// Area of life context
enum LifeContextArea {
  WORK @alias("work")
  RELATIONSHIPS @alias("relationships")
  HEALTH @alias("health")
  PERSONAL @alias("personal")
  OTHER @alias("other")
}

/// Detected pattern or theme
class PatternIntelligence {
  id string
  pattern string
  frequency int
  trend PatternTrend
  evidence PatternEvidence[]
  lastOccurrence string  // ISO 8601
}

/// Trend direction for patterns
enum PatternTrend {
  INCREASING @alias("increasing")
  STABLE @alias("stable")
  DECREASING @alias("decreasing")
}

/// Evidence supporting a pattern
class PatternEvidence {
  sessionId string
  sessionDate string  // ISO 8601
  quote string
  timestamp string?  // Optional timestamp within session
}

/// AI-generated conversation starter
class SuggestedOpener {
  question string
  rationale string
  category OpenerCategory
}

/// Category of opener question
enum OpenerCategory {
  COMMITMENT @alias("commitment")
  PATTERN @alias("pattern")
  CONTEXT @alias("context")
  EXPLORATION @alias("exploration")
}

/// Event from between sessions
class BetweenSessionEvent {
  id string
  type BetweenSessionEventType
  summary string
  sentiment Sentiment?
  timestamp string  // ISO 8601
}

/// Type of between-session event
enum BetweenSessionEventType {
  CHECK_IN @alias("check_in")
  JOURNAL @alias("journal")
  COMPLETION @alias("completion")
  CONVERSATION @alias("conversation")
}

/// Sentiment indicator
enum Sentiment {
  POSITIVE @alias("positive")
  NEUTRAL @alias("neutral")
  NEGATIVE @alias("negative")
}

/// Coachee's pre-session input
class CoacheePreSessionInput {
  submitted bool
  submittedAt string?  // ISO 8601
  topics string[]?
  updates string?
  questions string[]?
  moodRating int?  // 1-10 scale
}

// -----------------------------------------------------------------------------
// PrepTemplate and Section Configuration
// -----------------------------------------------------------------------------

/// Identifiers for prep sections
enum PrepSectionId {
  NORTH_STAR @alias("north_star")
  LAST_SESSION @alias("last_session")
  COMMITMENTS @alias("commitments")
  LIFE_CONTEXT @alias("life_context")
  PATTERNS @alias("patterns")
  OPENERS @alias("openers")
  PRIVATE_NOTES @alias("private_notes")
  BETWEEN_SESSION @alias("between_session")
  COACHEE_INPUT @alias("coachee_input")
}

/// Template for coach's prep preferences
class PrepTemplate {
  id string
  coachId int
  name string
  sectionsEnabled PrepSectionId[]
  defaultExpanded PrepSectionId[]
}

// -----------------------------------------------------------------------------
// Request/Response Types
// -----------------------------------------------------------------------------

/// Request to generate a prep document
class GeneratePrepRequest {
  sessionId string
  regenerate bool
}

/// Request to update private notes
class UpdatePrepNotesRequest {
  privateCoachNotes string
}

/// Response containing generated prep
class PrepResponse {
  success bool
  document PrepDocument?
  error string?
  warnings string[]
  generationTimeMs int
}

/// Lightweight summary for list views
class PrepSummary {
  id string
  sessionId string
  clientId int
  clientName string
  sessionDateTime string  // ISO 8601
  status PrepStatus
  generatedAt string  // ISO 8601
}

/// List of preps with pagination
class PrepList {
  items PrepSummary[]
  total int
  page int
  pageSize int
}
