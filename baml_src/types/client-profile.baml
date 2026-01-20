// =============================================================================
// Client Profile Types
// =============================================================================
// Types for client profile information including personal details,
// coaching context, and aggregated statistics.
// =============================================================================

// -----------------------------------------------------------------------------
// Client Profile
// -----------------------------------------------------------------------------

/// Full client profile
class ClientProfile {
  id int
  name string
  email string
  phone string?
  company string?
  title string?
  bio string?

  // North Star elements
  values string[]
  vision string?
  overarchingGoals string[]

  // Statistics
  totalSessions int
  completedGoals int
  activeGoals int
  pendingActions int

  // Dates
  lastSessionDate string?  // ISO 8601
  nextSessionDate string?  // ISO 8601
  coachingStartDate string  // ISO 8601
}

/// Lightweight client summary for list views
class ClientSummary {
  id int
  name string
  email string
  company string?
  totalSessions int
  lastSessionDate string?  // ISO 8601
  nextSessionDate string?  // ISO 8601
}

/// List of clients with pagination
class ClientList {
  items ClientSummary[]
  total int
  page int
  pageSize int
}

// -----------------------------------------------------------------------------
// Profile Updates
// -----------------------------------------------------------------------------

/// Request to update client profile
class UpdateClientProfileRequest {
  name string?
  email string?
  phone string?
  company string?
  title string?
  bio string?
  values string[]?
  vision string?
  overarchingGoals string[]?
}

/// Response from profile update
class UpdateClientProfileResponse {
  success bool
  profile ClientProfile?
  error string?
}

// -----------------------------------------------------------------------------
// Client Notes
// -----------------------------------------------------------------------------

/// Private coach notes about a client
class ClientNote {
  id string
  clientId int
  content string
  createdAt string  // ISO 8601
  updatedAt string  // ISO 8601
}

/// List of client notes
class ClientNoteList {
  items ClientNote[]
  total int
}

// -----------------------------------------------------------------------------
// Client Statistics
// -----------------------------------------------------------------------------

/// Client engagement statistics
class ClientStats {
  clientId int
  totalSessions int
  averageSessionDuration int  // minutes
  completedGoals int
  activeGoals int
  completedActions int
  pendingActions int
  averageMoodRating float?  // 1-10
  sessionFrequency float  // sessions per month
  coachingDurationMonths int
}
