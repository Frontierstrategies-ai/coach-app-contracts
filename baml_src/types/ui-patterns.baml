// =============================================================================
// UI Pattern Types
// =============================================================================
// Shared types for UI patterns used across the application,
// including accordion sections and disclosure levels.
// =============================================================================

// -----------------------------------------------------------------------------
// Accordion Section
// -----------------------------------------------------------------------------

/// Accordion section for expandable UI components
class AccordionSection {
  id string
  title string
  summary string?
  level int  // Nesting level (0 = top level)
  expanded bool
  children AccordionSection[]?
}

/// Accordion group configuration
class AccordionGroup {
  id string
  sections AccordionSection[]
  allowMultipleExpanded bool
  defaultExpandedIds string[]
}

// -----------------------------------------------------------------------------
// Disclosure Levels
// -----------------------------------------------------------------------------

/// Level of detail to disclose in UI
enum DisclosureLevel {
  SUMMARY @alias("summary")          // Brief overview only
  HEADINGS @alias("headings")        // Section headers
  KEY_POINTS @alias("key_points")    // Key points without details
  FULL_DETAIL @alias("full_detail")  // All content
  EXACT_QUOTE @alias("exact_quote")  // Include exact quotes
  TIMESTAMP @alias("timestamp")       // Include timestamps
}

/// Disclosure configuration
class DisclosureConfig {
  defaultLevel DisclosureLevel
  allowToggle bool
  expandByDefault bool
}

// -----------------------------------------------------------------------------
// Card Patterns
// -----------------------------------------------------------------------------

/// Card component data
class CardData {
  id string
  title string
  subtitle string?
  description string?
  icon string?
  badge string?
  badgeVariant BadgeVariant?
  actions CardAction[]?
}

/// Card action button
class CardAction {
  id string
  label string
  icon string?
  variant ActionVariant
  disabled bool?
}

/// Badge style variants
enum BadgeVariant {
  DEFAULT @alias("default")
  PRIMARY @alias("primary")
  SECONDARY @alias("secondary")
  SUCCESS @alias("success")
  WARNING @alias("warning")
  DANGER @alias("danger")
  INFO @alias("info")
}

/// Action button variants
enum ActionVariant {
  PRIMARY @alias("primary")
  SECONDARY @alias("secondary")
  GHOST @alias("ghost")
  LINK @alias("link")
  DANGER @alias("danger")
}

// -----------------------------------------------------------------------------
// List Patterns
// -----------------------------------------------------------------------------

/// List item data
class ListItem {
  id string
  primary string
  secondary string?
  meta string?
  avatar string?
  selected bool?
  disabled bool?
}

/// Grouped list data
class GroupedList {
  id string
  groups ListGroup[]
}

/// A group within a list
class ListGroup {
  id string
  title string
  items ListItem[]
  collapsible bool?
  collapsed bool?
}

// -----------------------------------------------------------------------------
// Empty State
// -----------------------------------------------------------------------------

/// Empty state configuration
class EmptyState {
  icon string?
  title string
  description string?
  actionLabel string?
  actionHref string?
}

// -----------------------------------------------------------------------------
// Loading State
// -----------------------------------------------------------------------------

/// Loading state configuration
class LoadingState {
  message string?
  showProgress bool?
  progress int?  // 0-100
}
