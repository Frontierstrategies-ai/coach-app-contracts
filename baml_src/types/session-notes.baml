// =============================================================================
// Session Notes Types - Post-Session Documentation
// =============================================================================
// These types define the session notes structure generated after coaching
// sessions. The document is organized into 6 sections following the coaching
// methodology: Recap, Observations, Inquiries, Invitations, Resources, Next.
// =============================================================================

// -----------------------------------------------------------------------------
// Session Note Section Enum
// -----------------------------------------------------------------------------

/// The 6 sections of session notes following ROIIRN methodology
enum SessionNoteSection {
  RECAP @alias("recap")              // What happened in the session
  OBSERVATIONS @alias("observations") // Coach's observations about the client
  INQUIRIES @alias("inquiries")       // Powerful questions explored
  INVITATIONS @alias("invitations")   // Invitations/challenges given to client
  RESOURCES @alias("resources")       // Resources shared or referenced
  NEXT @alias("next")                 // Next steps and action items
}

// -----------------------------------------------------------------------------
// Session Note Content Types
// -----------------------------------------------------------------------------

/// Content for a single session note section
class SessionSectionContent {
  section SessionNoteSection
  title string
  content string  // Rich text / markdown content
  bulletPoints string[]  // Key points as list
  aiGenerated bool  // Whether AI generated or coach wrote
  coachEdited bool  // Whether coach modified AI content
  lastEditedAt string?  // ISO 8601
}

/// Full session notes document
class SessionNotesDocument {
  id string
  sessionId int
  clientId int
  clientName string
  sessionDate string  // ISO 8601 - when session occurred
  sessionDuration int  // minutes
  sections SessionSectionContent[]
  summary string  // Brief overall session summary
  keyInsights string[]  // Top insights from the session
  followUpDate string?  // ISO 8601 - suggested follow-up date
  generatedAt string  // ISO 8601
  lastUpdatedAt string  // ISO 8601
  status SessionNotesStatus
  version int  // Document version for tracking edits
}

/// Status of session notes document
enum SessionNotesStatus {
  DRAFT @alias("draft")           // AI generated, not reviewed
  IN_REVIEW @alias("in_review")   // Coach is reviewing/editing
  FINALIZED @alias("finalized")   // Coach has approved
  SHARED @alias("shared")         // Shared with coachee (if applicable)
}

// -----------------------------------------------------------------------------
// Session Notes Request/Response Types
// -----------------------------------------------------------------------------

/// Request to generate session notes
class SessionNotesRequest {
  sessionId int
  clientId int
  transcript string?  // Optional transcript if available
  coachRunningNotes string?  // Coach's in-session notes
  includeSections SessionNoteSection[]  // Empty = all sections
  regenerate bool  // Force regeneration even if exists
}

/// Response containing generated session notes
class SessionNotesResponse {
  success bool
  document SessionNotesDocument?
  error string?
  warnings string[]  // e.g., "Transcript quality was low"
  generationTimeMs int
}

/// Request to update a specific section
class SessionSectionUpdateRequest {
  notesId string
  section SessionNoteSection
  content string?
  bulletPoints string[]
  markAsEdited bool  // Should mark this section as coach-edited
}

/// Response from section update
class SessionSectionUpdateResponse {
  success bool
  updatedSection SessionSectionContent?
  error string?
}

/// Request to finalize/approve session notes
class SessionNotesFinalizeRequest {
  notesId string
  shareWithCoachee bool  // Whether to share with the client
  personalizedMessage string?  // Optional message when sharing
}

/// Response from finalizing notes
class SessionNotesFinalizeResponse {
  success bool
  status SessionNotesStatus
  sharedAt string?  // ISO 8601, if shared
  error string?
}

// -----------------------------------------------------------------------------
// Session Notes Summary Types
// -----------------------------------------------------------------------------

/// Lightweight summary for list views
class SessionNotesSummary {
  id string
  sessionId int
  clientId int
  clientName string
  sessionDate string  // ISO 8601
  status SessionNotesStatus
  completedSections int
  totalSections int
  summary string
  generatedAt string  // ISO 8601
}

/// List of session notes with pagination
class SessionNotesList {
  items SessionNotesSummary[]
  total int
  page int
  pageSize int
}

/// Filter options for session notes list
class SessionNotesFilter {
  clientId int?
  status SessionNotesStatus?
  fromDate string?  // ISO 8601
  toDate string?  // ISO 8601
  searchQuery string?
}
