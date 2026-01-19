// =============================================================================
// Onboarding Types - Coach Onboarding Workflow
// =============================================================================
// These types support the coach onboarding process, including profile setup,
// voice sample collection, integration configuration, and progress tracking.
// The onboarding consists of 8 phases that coaches complete sequentially.
// =============================================================================

// -----------------------------------------------------------------------------
// Onboarding Phase Enum
// -----------------------------------------------------------------------------

/// The 8 phases of coach onboarding
enum OnboardingPhase {
  ACCOUNT_CREATED @alias("account_created")       // Initial account setup
  PROFILE_SETUP @alias("profile_setup")           // Basic profile information
  VOICE_SAMPLES @alias("voice_samples")           // Writing sample collection
  COACHING_STYLE @alias("coaching_style")         // Methodology preferences
  INTEGRATIONS @alias("integrations")             // Calendar/CRM connections
  CLIENT_IMPORT @alias("client_import")           // Import existing clients
  TUTORIAL @alias("tutorial")                     // Platform walkthrough
  COMPLETED @alias("completed")                   // Onboarding finished
}

// -----------------------------------------------------------------------------
// Onboarding Progress Types
// -----------------------------------------------------------------------------

/// Progress for a single onboarding phase
class OnboardingPhaseProgress {
  phase OnboardingPhase
  status PhaseStatus
  startedAt string?  // ISO 8601
  completedAt string?  // ISO 8601
  skipped bool
  skipReason string?
  data map<string, string>  // Phase-specific collected data
}

/// Status of an onboarding phase
enum PhaseStatus {
  NOT_STARTED @alias("not_started")
  IN_PROGRESS @alias("in_progress")
  COMPLETED @alias("completed")
  SKIPPED @alias("skipped")
}

/// Overall onboarding progress
class OnboardingProgress {
  coachId int
  currentPhase OnboardingPhase
  phases OnboardingPhaseProgress[]
  overallProgress float  // 0-1, percentage complete
  startedAt string  // ISO 8601
  completedAt string?  // ISO 8601
  estimatedTimeRemaining int?  // minutes
  canSkipCurrent bool  // Whether current phase can be skipped
}

// -----------------------------------------------------------------------------
// Voice Sample Types
// -----------------------------------------------------------------------------

/// Type of voice sample for AI learning
enum VoiceSampleType {
  EMAIL @alias("email")                   // Email communication sample
  SESSION_NOTES @alias("session_notes")   // Session notes sample
  FOLLOW_UP @alias("follow_up")           // Follow-up message sample
  FEEDBACK @alias("feedback")             // Client feedback sample
  GENERAL @alias("general")               // General writing sample
}

/// A single voice sample for training
class VoiceSample {
  id string
  coachId int
  type VoiceSampleType
  content string  // The actual writing sample
  context string?  // Context about when/why this was written
  isPreferred bool  // Coach marks as particularly representative
  submittedAt string  // ISO 8601
  processedAt string?  // ISO 8601 - when AI processed it
  processingStatus VoiceSampleStatus
}

/// Processing status for voice sample
enum VoiceSampleStatus {
  PENDING @alias("pending")       // Submitted, awaiting processing
  PROCESSING @alias("processing") // AI is analyzing
  PROCESSED @alias("processed")   // Successfully analyzed
  FAILED @alias("failed")         // Processing failed
}

/// Request to submit voice samples
class VoiceSampleSubmitRequest {
  samples VoiceSampleInput[]
}

/// Input for a single voice sample
class VoiceSampleInput {
  type VoiceSampleType
  content string
  context string?
  isPreferred bool
}

/// Response from voice sample submission
class VoiceSampleSubmitResponse {
  success bool
  submittedCount int
  sampleIds string[]
  voiceProfileStatus string  // e.g., "needs_more_samples", "ready_for_training"
  minimumSamplesRequired int
  currentSampleCount int
  error string?
}

// -----------------------------------------------------------------------------
// Integration Types
// -----------------------------------------------------------------------------

/// Types of integrations supported
enum IntegrationType {
  GOOGLE_CALENDAR @alias("google_calendar")
  OUTLOOK_CALENDAR @alias("outlook_calendar")
  ZOOM @alias("zoom")
  GOOGLE_MEET @alias("google_meet")
  TEAMS @alias("teams")
  SALESFORCE @alias("salesforce")
  HUBSPOT @alias("hubspot")
  PRACTICE @alias("practice")  // Practice management software
}

/// Status of an integration
enum IntegrationStatus {
  NOT_CONNECTED @alias("not_connected")
  PENDING @alias("pending")           // OAuth in progress
  CONNECTED @alias("connected")
  EXPIRED @alias("expired")           // Token expired
  ERROR @alias("error")
}

/// Configuration for a single integration
class IntegrationConfig {
  id string
  coachId int
  type IntegrationType
  status IntegrationStatus
  displayName string  // e.g., "John's Google Calendar"
  accountEmail string?  // Connected account email
  connectedAt string?  // ISO 8601
  lastSyncAt string?  // ISO 8601
  settings map<string, string>  // Integration-specific settings
  error string?  // Error message if status is ERROR
}

/// Request to initiate an integration connection
class IntegrationConnectRequest {
  type IntegrationType
  redirectUrl string  // Where to redirect after OAuth
}

/// Response with OAuth URL
class IntegrationConnectResponse {
  success bool
  authUrl string?  // URL to redirect user to for OAuth
  error string?
}

/// Request to disconnect an integration
class IntegrationDisconnectRequest {
  integrationId string
}

/// List of coach's integrations
class IntegrationList {
  integrations IntegrationConfig[]
  availableTypes IntegrationType[]  // Types that can still be connected
}

// -----------------------------------------------------------------------------
// Profile Scraping Types
// -----------------------------------------------------------------------------

/// Scraped coach profile from external sources
class ScrapedCoachProfile {
  source string  // e.g., "linkedin", "website", "icf"
  sourceUrl string
  name string?
  title string?
  bio string?
  certifications string[]
  specialties string[]
  yearsExperience int?
  photoUrl string?
  contactEmail string?
  scrapedAt string  // ISO 8601
  confidence float  // 0-1, confidence in scraped data accuracy
}

/// Request to scrape coach profile
class ProfileScrapeRequest {
  urls string[]  // URLs to scrape
  linkedInUrl string?
  websiteUrl string?
}

/// Response from profile scraping
class ProfileScrapeResponse {
  success bool
  profiles ScrapedCoachProfile[]
  mergedProfile ScrapedCoachProfile?  // AI-merged best data
  error string?
}

// -----------------------------------------------------------------------------
// Onboarding API Types
// -----------------------------------------------------------------------------

/// Request to update onboarding progress
class OnboardingUpdateRequest {
  phase OnboardingPhase
  action OnboardingAction
  data map<string, string>  // Phase-specific data
}

/// Onboarding action type
enum OnboardingAction {
  START @alias("start")
  COMPLETE @alias("complete")
  SKIP @alias("skip")
  SAVE_PROGRESS @alias("save_progress")
}

/// Response from onboarding update
class OnboardingUpdateResponse {
  success bool
  progress OnboardingProgress
  nextPhase OnboardingPhase?
  error string?
}
