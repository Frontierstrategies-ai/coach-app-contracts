// =============================================================================
// State Types - User Active State Management Contracts
// =============================================================================
// These types define the API contracts for tracking user state across
// frontend and extension, enabling context-aware AI assistance.
// =============================================================================

// -----------------------------------------------------------------------------
// Navigation Types
// -----------------------------------------------------------------------------

/// Navigation option for available routes/actions
class NavigationOption {
  label string
  route string
  icon string?
}

// -----------------------------------------------------------------------------
// State Update Types
// -----------------------------------------------------------------------------

/// Source of state update
enum StateSource {
  FRONTEND @alias("frontend")
  EXTENSION @alias("extension")
}

/// Request to update user's active state
class StateUpdateRequest {
  page string
  clientId int?
  sessionId string?
  availableActions string[]
  navigationOptions NavigationOption[]
  source StateSource
}

/// Response from state update
class StateUpdateResponse {
  success bool
  stateId string
}

// -----------------------------------------------------------------------------
// State Response Types
// -----------------------------------------------------------------------------

/// Current user state (broadcast via WebSocket)
class UserActiveState {
  page string
  clientId int?
  clientName string?
  sessionId string?
  sessionDate string?  // ISO 8601
  availableActions string[]
  navigationOptions NavigationOption[]
  source StateSource?
  lastUpdated string?  // ISO 8601
}

// -----------------------------------------------------------------------------
// State History Types (for debugging/audit)
// -----------------------------------------------------------------------------

/// Historical state entry
class StateHistoryEntry {
  id string
  userId int
  page string
  clientId int?
  sessionId string?
  source StateSource
  createdAt string  // ISO 8601
}

/// Request to query state history
class StateHistoryQuery {
  userId int?
  fromDate string?  // ISO 8601
  toDate string?  // ISO 8601
  limit int?
}
