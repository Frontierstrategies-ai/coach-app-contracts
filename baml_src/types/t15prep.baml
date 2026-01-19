// =============================================================================
// T-15 Prep Types - Pre-Session Preparation Document
// =============================================================================
// These types define the T-15 (15 minutes before session) prep document
// structure that helps coaches prepare for upcoming coaching sessions.
// The document is organized into 9 sections for comprehensive preparation.
// =============================================================================

// -----------------------------------------------------------------------------
// T-15 Prep Section Enum
// -----------------------------------------------------------------------------

/// The 9 sections of a T-15 prep document (matches backend spec)
enum T15PrepSection {
  NORTH_STAR_REMINDER @alias("north_star_reminder")         // Client's articulated purpose
  LAST_SESSION_RECAP @alias("last_session_recap")           // Recap of previous session
  COMMITMENTS_TO_CHECK @alias("commitments_to_check")       // Commitments from last session
  LIFE_CONTEXT @alias("life_context")                       // Recent life events, updates
  PATTERN_INTELLIGENCE @alias("pattern_intelligence")       // Detected patterns and themes
  SUGGESTED_OPENERS @alias("suggested_openers")             // AI-generated conversation starters
  PRIVATE_COACH_NOTES @alias("private_coach_notes")         // Coach's private notes (manual)
  BETWEEN_SESSION_INTELLIGENCE @alias("between_session_intelligence")  // Summary of coachee-AI convos
  COACHEE_PRE_SESSION_INPUT @alias("coachee_pre_session_input")       // Coachee's pre-session input
}

// -----------------------------------------------------------------------------
// T-15 Prep Content Types
// -----------------------------------------------------------------------------

/// Content for a single T-15 section
class T15SectionContent {
  section T15PrepSection
  title string
  content string  // Rich text / markdown content
  bulletPoints string[]  // Key points as list
  priority int  // 1-5, higher = more important
  aiConfidence float  // 0-1, AI's confidence in this section
}

/// Full T-15 prep document
class T15PrepDocument {
  id string
  sessionId int
  clientId int
  clientName string
  scheduledAt string  // ISO 8601 - session start time
  sections T15SectionContent[]
  overallReadiness string  // AI assessment of session readiness
  generatedAt string  // ISO 8601
  lastUpdatedAt string  // ISO 8601
  version int  // Document version for regeneration tracking
}

// -----------------------------------------------------------------------------
// T-15 Prep Request/Response Types
// -----------------------------------------------------------------------------

/// Request to generate a T-15 prep document
class T15PrepRequest {
  sessionId int
  clientId int
  includeSections T15PrepSection[]  // Empty = all sections
  regenerate bool  // Force regeneration even if exists
  focusAreas string[]  // Optional coach-specified focus areas
}

/// Response containing generated T-15 prep
class T15PrepResponse {
  success bool
  document T15PrepDocument?
  error string?
  warnings string[]  // e.g., "Limited data for observations section"
  generationTimeMs int
}

/// Request to update a specific section
class T15SectionUpdateRequest {
  prepId string
  section T15PrepSection
  content string?
  bulletPoints string[]
  coachNotes string?  // Coach's additions/modifications
}

/// Response from section update
class T15SectionUpdateResponse {
  success bool
  updatedSection T15SectionContent?
  error string?
}

// -----------------------------------------------------------------------------
// T-15 Prep Summary Types
// -----------------------------------------------------------------------------

/// Lightweight summary for list views
class T15PrepSummary {
  id string
  sessionId int
  clientId int
  clientName string
  scheduledAt string  // ISO 8601
  generatedAt string  // ISO 8601
  completedSections int
  totalSections int
  overallReadiness string
}

/// List of T-15 preps with pagination
class T15PrepList {
  items T15PrepSummary[]
  total int
  page int
  pageSize int
}
