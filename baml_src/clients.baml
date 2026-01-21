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

// Groq client (OpenAI-compatible) for voice learning when Anthropic is unavailable
client<llm> GroqNormal {
  provider openai-generic
  options {
    base_url "https://api.groq.com/openai/v1"
    api_key env.GROQ_API_KEY
    model "llama-3.3-70b-versatile"
    default_role "user"
  }
}
