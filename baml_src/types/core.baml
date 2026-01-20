// =============================================================================
// Core Types - Boundary DTOs for Frontend/Backend Communication
// =============================================================================
// These types represent the foundational contracts shared between
// coach-app-frontend and coach-app-backend.
// =============================================================================

// -----------------------------------------------------------------------------
// Message Role Enum
// -----------------------------------------------------------------------------

enum MessageRole {
  USER
  ASSISTANT
  SYSTEM
}

// -----------------------------------------------------------------------------
// Tool Enums
// -----------------------------------------------------------------------------

/// Backend tool names for action execution
enum ToolName {
  DRAFT_T15
  DRAFT_SESSION_NOTES
  SEND_FOLLOW_UP_EMAIL
  UPDATE_SESSION_STATUS
  SUMMARIZE_TRANSCRIPT
  ADD_CLIENT_NOTE
  SCHEDULE_SESSION
  LOOKUP_CLIENT
}

/// Frontend tool names - execute on frontend, not backend
enum FrontendToolName {
  NAVIGATE_TO
  CLICK_ELEMENT
  EXPAND_SECTION
  SET_FORM_FIELD
  SUBMIT_FORM
  OPEN_MODAL
  CLOSE_MODAL
}

/// Frontend action status lifecycle
enum FrontendActionStatus {
  PENDING @alias("pending")
  EXECUTING @alias("executing")
  COMPLETED @alias("completed")
  FAILED @alias("failed")
  EXPIRED @alias("expired")
}

// -----------------------------------------------------------------------------
// Page Context Types
// -----------------------------------------------------------------------------

/// Page context from extension content script
class PageContext {
  url string
  route string?
  clientId int?
  sessionId string?  // UUID format (was int, changed for UUID compatibility)
  pageTitle string?
  pageData map<string, string>  // Additional extracted data
}

/// Resolved context (what the system understood from PageContext)
class ResolvedContext {
  clientId int?
  clientName string?
  sessionId string?  // UUID format (was int, changed for UUID compatibility)
  sessionDate string?
  confidence float  // 0-1, confidence in resolution
}

// -----------------------------------------------------------------------------
// Chat Message Types
// -----------------------------------------------------------------------------

/// Single chat message
class ChatMessage {
  role MessageRole
  content string
  timestamp string  // ISO 8601
}

/// Chat request from extension to backend
class ChatRequest {
  message string
  context PageContext?
  conversationHistory ChatMessage[]?  // Optional - backend can retrieve from DB if not provided
  conversationId string?
}

/// Suggested action (Phase 2+)
class SuggestedAction {
  tool ToolName
  label string
  description string
  parameters map<string, string>
  requiresConfirmation bool
}

/// Chat response from backend to extension
class ChatResponse {
  message string
  conversationId string
  suggestedActions SuggestedAction[]
  context ResolvedContext?
  frontendCommands FrontendCommand[]?  // Commands for frontend to execute (Phase 2.5+)
}

// -----------------------------------------------------------------------------
// Auth Types
// -----------------------------------------------------------------------------

class AuthVerifyResponse {
  authenticated bool
  userId int?
  username string?
  email string?
  firstName string?
  lastName string?
  organizationId int?
  permissions string[]
}

// -----------------------------------------------------------------------------
// Error Types
// -----------------------------------------------------------------------------

class ActionError {
  code string
  message string
  retryable bool
  details map<string, string>
}

// -----------------------------------------------------------------------------
// Tool Parameter Types
// -----------------------------------------------------------------------------

class ToolParameter {
  name string
  type string  // "string" | "int" | "bool" | "date" | "text"
  description string
  required bool
  default string?
}

class ToolDefinition {
  name ToolName
  description string
  parameters ToolParameter[]
  requiresConfirmation bool
  outputType string  // "text" | "structured" | "void"
}

// -----------------------------------------------------------------------------
// Action Request/Response Types
// -----------------------------------------------------------------------------

class ActionOutput {
  type string  // "text" | "structured"
  text string?
  structured map<string, string>
  preview string?
}

class ActionRequest {
  conversationId string
  tool ToolName
  parameters map<string, string>
  context PageContext
  confirmed bool
}

class ActionResponse {
  success bool
  actionId string?  // UUID of the action log entry (for tracking)
  tool ToolName
  output ActionOutput?
  error ActionError?
  appliedChanges string[]
  followUpMessage string?
  suggestedNextActions SuggestedAction[]
}

// -----------------------------------------------------------------------------
// Context Types (for enriched context)
// -----------------------------------------------------------------------------

class ClientContext {
  id int
  name string
  email string?
  phone string?
  goals string[]
  recentNotes string?
  lastSessionDate string?
  nextSessionDate string?
  totalSessions int
}

class SessionContext {
  id string  // UUID format (was int, changed for UUID compatibility)
  clientId int
  clientName string
  scheduledAt string
  status string
  t15Summary string?
  notes string?
  transcript string?
  runningNotes string?
}

// -----------------------------------------------------------------------------
// Frontend Command Types (Bidirectional Command Execution)
// -----------------------------------------------------------------------------

/// Command sent to frontend via WebSocket
class FrontendCommand {
  actionId string
  tool FrontendToolName
  parameters map<string, string>
  timeout int  // milliseconds
  requiresConfirmation bool
}

/// Result reported back by frontend
class FrontendActionResult {
  actionId string
  status FrontendActionStatus
  success bool
  message string?
  error ActionError?
  executedAt string  // ISO 8601
}

/// Tool configuration for admin panel
class FrontendToolConfig {
  tool FrontendToolName
  requiresConfirmation bool
  defaultTimeout int
}
