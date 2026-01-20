// =============================================================================
// BAML Client Definitions
// =============================================================================
// Defines LLM client configurations used by BAML functions.
// These clients are used for AI-powered features like voice learning.
// =============================================================================

// Claude client for voice learning and style analysis functions
client<llm> Claude {
  provider anthropic
  options {
    model "claude-sonnet-4-20250514"
    api_key env.ANTHROPIC_API_KEY
  }
}
