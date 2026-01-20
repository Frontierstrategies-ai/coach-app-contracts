# Phase III Contracts Implementation Planning Prompt

## Purpose

This document provides the planning context for the contracts team to implement Phase III BAML types in sync with frontend and backend. Use this as a comprehensive guide when planning contracts work.

---

## Phase III Overview

**Timeline:** Weeks 16-21 (6 weeks)
**Outcome:** BAML type definitions supporting T-15 Prep View, 6-section session notes, and enhanced ReGenesis features.

**Frontend Plan:** See `coach-app-frontend/specs/planning/phase3-frontend-plan.md`
**Backend Plan:** See `coach-app-backend/specs/planning/phase3-backend-planning-prompt.md`

---

## Planning Instructions

When planning Phase III contracts implementation, you must:

1. **Explicitly mention every file, class, enum, function** that needs to be added, modified, or deleted
2. **Explain the reason** for each addition, modification, or deletion
3. **Ensure types cross repository boundaries** - only types needed by both frontend and backend belong here
4. **Coordinate with frontend and backend** on exact type shapes
5. **Generate both Python and TypeScript** clients

---

## Repository Structure

```
coach-app-contracts/
├── baml_src/
│   ├── generators.baml          # Python + TypeScript generation config
│   └── types/
│       ├── core.baml            # PageContext, ChatRequest, ChatResponse
│       ├── events.baml          # EventEnvelope, event payloads
│       ├── features.baml        # VoiceCorrection, CommandCenterItem, etc.
│       ├── messaging.baml       # ScheduledMessage types
│       ├── onboarding.baml      # OnboardingProgress
│       ├── session-notes.baml   # SessionNotes DTOs
│       ├── state.baml           # UserActiveState
│       ├── t15prep.baml         # T-15 Prep types (existing or create)
│       └── voice-learning-v1.baml # Voice sample types
└── packages/
    ├── python/                  # Generated Pydantic models
    └── typescript/              # Generated TypeScript types
```

---

## P0 Types (Critical)

### 1. T-15 Prep Document Types

**File:** `baml_src/types/t15prep.baml` (CREATE or MODIFY)
**Reason:** Define all types for T-15 prep document system.

```baml
// T-15 Prep Document Types

// Main prep document returned by API
class PrepDocument {
  id string
  sessionId string
  clientId int
  clientName string
  sessionTitle string
  sessionDateTime string

  // 9 Sections
  northStarReminder NorthStarReminder
  lastSessionRecap LastSessionRecap
  commitments Commitment[]
  lifeContext LifeContextItem[]
  patternIntelligence PatternIntelligence[]
  suggestedOpeners SuggestedOpener[]
  privateCoachNotes string
  betweenSessionIntelligence BetweenSessionEvent[]
  coacheePreSessionInput CoacheePreSessionInput

  generatedAt string
  status PrepStatus
}

enum PrepStatus {
  draft
  ready
  viewed
}

// Section 1: North Star Reminder
class NorthStarReminder {
  values string[]
  vision string
  overarchingGoals string[]
}

// Section 2: Last Session Recap
class LastSessionRecap {
  themes string[]
  breakthroughs string[]
  emotionalMoments string[]
  summary string
  sessionDate string
}

// Section 3: Commitments to Check
class Commitment {
  id string
  description string
  status CommitmentStatus
  source CommitmentSource
  sessionId string?
  createdAt string
}

enum CommitmentStatus {
  completed
  pending
  partial
  unknown
}

enum CommitmentSource {
  session
  between_session
}

// Section 4: Life Context
class LifeContextItem {
  area LifeContextArea
  summary string
  source string
  updatedAt string
}

enum LifeContextArea {
  work
  relationships
  health
  personal
  other
}

// Section 5: Pattern Intelligence
class PatternIntelligence {
  id string
  pattern string
  frequency int
  trend PatternTrend
  evidence PatternEvidence[]
  lastOccurrence string
}

enum PatternTrend {
  increasing
  stable
  decreasing
}

class PatternEvidence {
  sessionId string
  sessionDate string
  quote string
  timestamp string?
}

// Section 6: Suggested Openers
class SuggestedOpener {
  question string
  rationale string
  category OpenerCategory
}

enum OpenerCategory {
  commitment
  pattern
  context
  exploration
}

// Section 7: Private Coach Notes (stored as string)

// Section 8: Between-Session Intelligence
class BetweenSessionEvent {
  id string
  type BetweenSessionEventType
  summary string
  sentiment Sentiment?
  timestamp string
}

enum BetweenSessionEventType {
  check_in
  journal
  completion
  conversation
}

enum Sentiment {
  positive
  neutral
  negative
}

// Section 9: Coachee Pre-Session Input
class CoacheePreSessionInput {
  submitted bool
  submittedAt string?
  topics string[]?
  updates string?
  questions string[]?
  moodRating int?
}

// Prep Section IDs for template configuration
enum PrepSectionId {
  north_star
  last_session
  commitments
  life_context
  patterns
  openers
  private_notes
  between_session
  coachee_input
}

// Prep Template configuration
class PrepTemplate {
  id string
  coachId int
  name string
  sectionsEnabled PrepSectionId[]
  defaultExpanded PrepSectionId[]
}

// API Request/Response types
class GeneratePrepRequest {
  sessionId string
  regenerate bool
}

class UpdatePrepNotesRequest {
  privateCoachNotes string
}
```

### 2. 6-Section Session Notes Types

**File:** `baml_src/types/session-notes.baml` (MODIFY if exists, CREATE if not)
**Reason:** Define structured session notes types.

```baml
// 6-Section Session Notes Types

enum SessionNoteSectionId {
  recap
  observations
  inquiries
  invitations
  resources
  next
}

class SessionNotes {
  sessionId string
  recap SessionNoteSection
  observations SessionNoteSection
  inquiries InquiriesSection
  invitations InvitationsSection
  resources ResourcesSection
  next NextSection
  voiceConfidence float
  generatedAt string
  lastEditedAt string?
  status SessionNotesStatus
}

enum SessionNotesStatus {
  draft
  sent
  archived
}

class SessionNoteSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
}

class KeyPoint {
  id string
  text string
  detail string?
  quote Quote?
}

class Quote {
  text string
  timestamp string?
  videoLink string?
}

// Section 3: Inquiries - extends SessionNoteSection
class InquiriesSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
  questions InquiryQuestion[]
}

class InquiryQuestion {
  id string
  question string
  category InquiryCategory
  answered bool?
}

enum InquiryCategory {
  growth
  reflection
  challenge
  exploration
}

// Section 4: Invitations - extends SessionNoteSection
class InvitationsSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
  actionItems ActionItem[]
}

class ActionItem {
  id string
  action string
  specificity ActionSpecificity
  details string
  dueDate string?
  completed bool?
}

enum ActionSpecificity {
  when
  what
  how
  who
}

// Section 5: Resources - extends SessionNoteSection
class ResourcesSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
  links ResourceLink[]
}

class ResourceLink {
  id string
  title string
  url string
  type ResourceLinkType
  description string?
}

enum ResourceLinkType {
  document
  link
  framework
}

// Section 6: Next - extends SessionNoteSection
class NextSection {
  id string
  summary string
  keyPoints KeyPoint[]
  expanded bool?
  focusAreas string[]
  nextSessionDate string?
}

// API Request/Response types
class GenerateNotesRequest {
  sessionId string
  regenerate bool
}

class UpdateSectionRequest {
  sectionId SessionNoteSectionId
  content map<string, any>
}
```

### 3. Dashboard Types

**File:** `baml_src/types/dashboard.baml` (CREATE)
**Reason:** Types for new dashboard widgets.

```baml
// Dashboard Types

class SessionPrepStatus {
  sessionId string
  clientName string
  sessionDateTime string
  prepStatus PrepStatusValue
  timeUntilSession int  // minutes
}

enum PrepStatusValue {
  not_started
  generating
  ready
  viewed
}

class RecentClient {
  id int
  name string
  lastSessionDate string?
  nextSessionDate string?
  pendingActionsCount int
}

class DashboardSection {
  id string
  title string
  priority int
  visible bool
  collapsed bool
}
```

### 4. Client Goals Types

**File:** `baml_src/types/client-goals.baml` (CREATE)
**Reason:** Types for client goals management.

```baml
// Client Goals Types

class ClientGoal {
  id string
  clientId int
  title string
  description string?
  category GoalCategory
  status GoalStatus
  progress int  // 0-100
  targetDate string?
  completedAt string?
  createdAt string
  updatedAt string
}

enum GoalCategory {
  career
  leadership
  relationships
  personal
  health
  other
}

enum GoalStatus {
  active
  completed
  paused
  archived
}

class CreateGoalRequest {
  title string
  description string?
  category GoalCategory
  targetDate string?
}

class UpdateGoalRequest {
  title string?
  description string?
  category GoalCategory?
  status GoalStatus?
  progress int?
  targetDate string?
}
```

### 5. Client Profile Types

**File:** `baml_src/types/client-profile.baml` (CREATE)
**Reason:** Unified client profile response type.

```baml
// Client Profile Types

class ClientProfile {
  id int
  name string
  email string
  phone string?
  company string?
  title string?
  bio string?

  // North Star
  values string[]
  vision string?
  overarchingGoals string[]

  // Stats
  totalSessions int
  completedGoals int
  activeGoals int
  pendingActions int

  // Recent activity
  lastSessionDate string?
  nextSessionDate string?
  coachingStartDate string
}
```

---

## P1 Types (High Priority)

### 6. WebSocket Event Types for Prep Notifications

**File:** `baml_src/types/events.baml` (MODIFY)
**Reason:** Add prep notification event types.

```baml
// Add to existing events.baml

// Prep notification event
class PrepNotificationEvent {
  sessionId string
  clientName string
  sessionDateTime string
  prepStatus PrepStatus
  minutesUntilSession int
}

// Add to EventType enum
enum EventType {
  // ... existing types ...
  prep_notification
  prep_ready
  prep_viewed
}
```

### 7. Accordion/Progressive Disclosure Types

**File:** `baml_src/types/ui-patterns.baml` (CREATE)
**Reason:** Types for nested accordion progressive disclosure.

```baml
// UI Pattern Types

class AccordionSection {
  id string
  title string
  summary string?
  level int  // 0-5
  expanded bool
  children AccordionSection[]?
}

enum DisclosureLevel {
  summary      // Level 1: Always visible
  headings     // Level 2: Section headings
  key_points   // Level 3: Key points
  full_detail  // Level 4: Full paragraphs
  exact_quote  // Level 5: Direct quotes
  timestamp    // Level 6: Video timestamps
}
```

---

## Files Summary

### Files to CREATE

| File | Purpose | Types Count |
|------|---------|-------------|
| `baml_src/types/t15prep.baml` | T-15 Prep types | 20+ |
| `baml_src/types/dashboard.baml` | Dashboard widget types | 5+ |
| `baml_src/types/client-goals.baml` | Client goals types | 6+ |
| `baml_src/types/client-profile.baml` | Unified profile types | 1 |
| `baml_src/types/ui-patterns.baml` | Accordion/disclosure types | 2 |
| `specs/planning/` | Planning docs directory | N/A |

### Files to MODIFY

| File | Changes |
|------|---------|
| `baml_src/types/session-notes.baml` | Add 6-section structure if not exists |
| `baml_src/types/events.baml` | Add prep notification events |
| `baml_src/generators.baml` | Verify Python + TypeScript generation |

---

## Implementation Checklist

### Week 16: Foundation Types
- [ ] Create `t15prep.baml` with all prep types
- [ ] Create `dashboard.baml` with widget types
- [ ] Verify generators.baml configuration
- [ ] Generate and test Python client
- [ ] Generate and test TypeScript client

### Week 17: Session Notes Types
- [ ] Create/update `session-notes.baml` with 6-section types
- [ ] Add all nested types (KeyPoint, Quote, ActionItem, etc.)
- [ ] Regenerate clients
- [ ] Verify type compatibility with backend serializers

### Week 18: Supporting Types
- [ ] Create `client-goals.baml`
- [ ] Create `client-profile.baml`
- [ ] Update `events.baml` with prep notifications
- [ ] Regenerate clients

### Week 19: UI Pattern Types
- [ ] Create `ui-patterns.baml`
- [ ] Add accordion/disclosure types
- [ ] Regenerate clients
- [ ] Test with frontend components

### Week 20-21: Integration
- [ ] End-to-end testing with frontend and backend
- [ ] Fix type mismatches
- [ ] Version bump
- [ ] Publish updated packages

---

## Type Generation

### Python Generation

Ensure `generators.baml` includes:

```baml
generator python {
  output_type "pydantic"
  output_dir "../packages/python"
  version "0.217.0"
}
```

### TypeScript Generation

Ensure `generators.baml` includes:

```baml
generator typescript {
  output_type "typescript"
  output_dir "../packages/typescript"
  version "0.217.0"
}
```

---

## Coordination Points

### With Frontend

| Type | Frontend Usage |
|------|----------------|
| `PrepDocument` | `useSessionPrep` hook return type |
| `SessionNotes` | `useSessionNotes` hook return type |
| `SessionPrepStatus` | Dashboard widget props |
| `ClientGoal` | Client goals tab props |
| `ClientProfile` | Client profile tab props |

### With Backend

| Type | Backend Usage |
|------|---------------|
| `PrepDocument` | `PrepDocumentResponseSerializer` |
| `SessionNotes` | `ClientSession.structured_notes` JSON schema |
| `PrepTemplate` | `PrepTemplate` model |
| `ClientGoal` | `ClientGoal` model serialization |

---

## Success Criteria

- [ ] All types generate without errors
- [ ] Python Pydantic models validate correctly
- [ ] TypeScript types compile without errors
- [ ] Frontend can import and use all types
- [ ] Backend serializers match type shapes
- [ ] No type mismatches between frontend and backend
- [ ] Package version bumped appropriately

---

## Versioning

Current version: Check `package.json` in packages directories

For Phase III release:
- Minor version bump for new types
- Update CHANGELOG.md
- Tag release in git
