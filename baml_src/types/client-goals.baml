// =============================================================================
// Client Goals Types
// =============================================================================
// Types for managing client goals, including creation, updates, and tracking.
// =============================================================================

// -----------------------------------------------------------------------------
// Goal Model
// -----------------------------------------------------------------------------

/// A client goal
class ClientGoal {
  id string
  clientId int
  title string
  description string?
  category GoalCategory
  status GoalStatus
  progress int  // 0-100 percentage
  targetDate string?  // ISO 8601
  completedAt string?  // ISO 8601
  createdAt string  // ISO 8601
  updatedAt string  // ISO 8601
}

/// Category of goal
enum GoalCategory {
  CAREER @alias("career")
  LEADERSHIP @alias("leadership")
  RELATIONSHIPS @alias("relationships")
  PERSONAL @alias("personal")
  HEALTH @alias("health")
  OTHER @alias("other")
}

/// Status of goal
enum GoalStatus {
  ACTIVE @alias("active")
  COMPLETED @alias("completed")
  PAUSED @alias("paused")
  ARCHIVED @alias("archived")
}

// -----------------------------------------------------------------------------
// Request Types
// -----------------------------------------------------------------------------

/// Request to create a new goal
class CreateGoalRequest {
  title string
  description string?
  category GoalCategory
  targetDate string?  // ISO 8601
}

/// Request to update an existing goal
class UpdateGoalRequest {
  title string?
  description string?
  category GoalCategory?
  status GoalStatus?
  progress int?
  targetDate string?  // ISO 8601
}

// -----------------------------------------------------------------------------
// Response Types
// -----------------------------------------------------------------------------

/// Response containing goal data
class GoalResponse {
  success bool
  goal ClientGoal?
  error string?
}

/// List of goals with pagination
class GoalList {
  items ClientGoal[]
  total int
  page int
  pageSize int
}

/// Filter options for goals list
class GoalFilter {
  clientId int?
  category GoalCategory?
  status GoalStatus?
  searchQuery string?
}

// -----------------------------------------------------------------------------
// Goal Progress
// -----------------------------------------------------------------------------

/// Goal progress update
class GoalProgressUpdate {
  goalId string
  progress int  // 0-100
  note string?
  updatedAt string  // ISO 8601
}

/// Goal milestone
class GoalMilestone {
  id string
  goalId string
  title string
  description string?
  targetDate string?  // ISO 8601
  completed bool
  completedAt string?  // ISO 8601
}
