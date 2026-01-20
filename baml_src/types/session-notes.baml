// =============================================================================
// 6-Section Session Notes Types (Typed Structure)
// =============================================================================
// Post-session documentation with typed sections following ROIIRN methodology.
// Breaking change in v2.0.0: Replaced generic SessionSectionContent[] with
// explicitly typed section fields as required by backend spec.
// =============================================================================

// -----------------------------------------------------------------------------
// Section Identifiers
// -----------------------------------------------------------------------------

/// The 6 sections of session notes
enum SessionNoteSectionId {
  RECAP @alias("recap")
  OBSERVATIONS @alias("observations")
  INQUIRIES @alias("inquiries")
  INVITATIONS @alias("invitations")
  RESOURCES @alias("resources")
  NEXT @alias("next")
}

// -----------------------------------------------------------------------------
// SessionNotes - Main Document Structure
// -----------------------------------------------------------------------------

/// Full session notes document with typed sections
class SessionNotes {
  sessionId string
  recap SessionNoteSection
  observations SessionNoteSection
  inquiries InquiriesSection
  invitations InvitationsSection
  resources ResourcesSection
  next NextSection
  voiceConfidence float  // 0-1, AI voice matching confidence
  generatedAt string  // ISO 8601
  lastEditedAt string?  // ISO 8601
  status SessionNotesStatus
}

/// Status of session notes
enum SessionNotesStatus {
  DRAFT @alias("draft")
  SENT @alias("sent")
  ARCHIVED @alias("archived")
}

// -----------------------------------------------------------------------------
// Base Section Types
// -----------------------------------------------------------------------------

/// Base structure for simple sections (recap, observations)
class SessionNoteSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
}

/// A key point within a section
class KeyPoint {
  id string
  text string
  detail string?
  quote Quote?
}

/// A quote from the session
class Quote {
  text string
  timestamp string?  // Position in session recording
  videoLink string?
}

// -----------------------------------------------------------------------------
// Specialized Section Types
// -----------------------------------------------------------------------------

/// Inquiries section with questions
class InquiriesSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
  questions InquiryQuestion[]
}

/// A powerful question explored in the session
class InquiryQuestion {
  id string
  question string
  category InquiryCategory
  answered bool?
}

/// Category of inquiry question
enum InquiryCategory {
  GROWTH @alias("growth")
  REFLECTION @alias("reflection")
  CHALLENGE @alias("challenge")
  EXPLORATION @alias("exploration")
}

/// Invitations section with action items
class InvitationsSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
  actionItems ActionItem[]
}

/// An action item or invitation given to client
class ActionItem {
  id string
  action string
  specificity ActionSpecificity
  details string
  dueDate string?  // ISO 8601
  completed bool?
}

/// Level of specificity for action items
enum ActionSpecificity {
  WHEN @alias("when")
  WHAT @alias("what")
  HOW @alias("how")
  WHO @alias("who")
}

/// Resources section with links
class ResourcesSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
  links ResourceLink[]
}

/// A resource link shared in the session
class ResourceLink {
  id string
  title string
  url string
  type ResourceLinkType
  description string?
}

/// Type of resource link
enum ResourceLinkType {
  DOCUMENT @alias("document")
  LINK @alias("link")
  FRAMEWORK @alias("framework")
}

/// Next section with focus areas
class NextSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
  focusAreas string[]
  nextSessionDate string?  // ISO 8601
}

// -----------------------------------------------------------------------------
// Request/Response Types
// -----------------------------------------------------------------------------

/// Request to generate session notes
class GenerateNotesRequest {
  sessionId string
  regenerate bool
}

/// Request to update a specific section
class UpdateSectionRequest {
  sectionId SessionNoteSectionId
  summary string?
  keyPoints KeyPoint[]?
}

/// Response containing generated notes
class SessionNotesResponse {
  success bool
  notes SessionNotes?
  error string?
  warnings string[]
  generationTimeMs int
}

/// Request to finalize/send session notes
class FinalizeNotesRequest {
  notesId string
  sendToClient bool
  personalizedMessage string?
}

/// Response from finalizing notes
class FinalizeNotesResponse {
  success bool
  status SessionNotesStatus
  sentAt string?  // ISO 8601, if sent
  error string?
}

// -----------------------------------------------------------------------------
// Summary Types
// -----------------------------------------------------------------------------

/// Lightweight summary for list views
class SessionNotesSummary {
  id string
  sessionId string
  clientId int
  clientName string
  sessionDate string  // ISO 8601
  status SessionNotesStatus
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
