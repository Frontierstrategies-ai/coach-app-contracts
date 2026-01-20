// =============================================================================
// Dashboard Types
// =============================================================================
// Types for the coach dashboard including session prep status,
// recent clients, and dashboard section configuration.
// =============================================================================

// -----------------------------------------------------------------------------
// Session Prep Status
// -----------------------------------------------------------------------------

/// Status of session preparation for dashboard display
class SessionPrepStatus {
  sessionId string
  clientId int
  clientName string
  sessionDateTime string  // ISO 8601
  sessionTitle string?
  prepStatus PrepStatusValue
  timeUntilSession int  // minutes
  needsAttention bool
  clientAvatarUrl string?
  meetLink string?
}

/// Prep status values
enum PrepStatusValue {
  NOT_STARTED @alias("not_started")
  GENERATING @alias("generating")
  READY @alias("ready")
  VIEWED @alias("viewed")
}

// -----------------------------------------------------------------------------
// Recent Clients
// -----------------------------------------------------------------------------

/// Recent client for dashboard display
class RecentClient {
  id int
  name string
  firstName string?
  lastName string?
  avatarUrl string?
  lastSessionDate string?  // ISO 8601
  nextSessionDate string?  // ISO 8601
  recentActivity string?
  hasPendingPrep bool
  pendingActionsCount int
  pendingMessages int?
}

// -----------------------------------------------------------------------------
// Dashboard Configuration
// -----------------------------------------------------------------------------

/// Dashboard section configuration
class DashboardSection {
  id string
  title string
  priority int  // Lower = higher priority
  visible bool
  collapsed bool
}

/// Dashboard layout preferences
class DashboardPreferences {
  coachId int
  sections DashboardSection[]
  defaultView DashboardView
  refreshInterval int  // seconds
}

/// Dashboard view options
enum DashboardView {
  OVERVIEW @alias("overview")
  SESSIONS @alias("sessions")
  CLIENTS @alias("clients")
  ACTIONS @alias("actions")
}

// -----------------------------------------------------------------------------
// Dashboard Data
// -----------------------------------------------------------------------------

/// Full dashboard data response
class DashboardData {
  upcomingSessions SessionPrepStatus[]
  recentClients RecentClient[]
  pendingActionsCount int
  todaySessionsCount int
  weekSessionsCount int
  lastUpdated string  // ISO 8601
}
