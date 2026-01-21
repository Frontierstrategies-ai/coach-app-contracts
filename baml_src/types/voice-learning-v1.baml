// =============================================================================
// Voice Learning v1 Types - LLM-Based Semantic Style Analysis
// =============================================================================
// These types support the enhanced Voice Learning system that uses LLM-based
// semantic analysis to understand coach communication style beyond word-level
// diff patterns. v1 adds ToneVector computation, StyleAnalysis, and human-readable
// insights for the style dashboard.
// =============================================================================

// -----------------------------------------------------------------------------
// Core v1 Types
// -----------------------------------------------------------------------------

/// 5-dimensional tone profile for measuring communication style
/// Each dimension is computed from analyzing correction patterns
class ToneVector {
  warmth float       // -1 (cold/clinical) to 1 (warm/friendly)
  formality float    // -1 (casual) to 1 (formal)
  directness float   // -1 (indirect/diplomatic) to 1 (direct/blunt)
  empathy float      // 0 (low) to 1 (high empathy expression)
  energy float       // -1 (calm/measured) to 1 (energetic/enthusiastic)
}

/// LLM-computed style profile aggregated from correction analysis
class StyleAnalysis {
  toneProfile ToneVector
  sentencePatterns string[]       // Preferred sentence structures (e.g., "short declarative", "question-then-insight")
  transitionPhrases string[]      // Connecting language (e.g., "That said,", "Building on that,")
  emotionalRegister string        // Overall tone descriptor (e.g., "warm and encouraging", "professionally supportive")
  rhetoricalPatterns string[]     // Patterns like questions, affirmations, challenges, reflections
  confidence float                // 0-1, improves with more correction data
  sampleCount int                 // Number of corrections analyzed
  lastUpdated string              // ISO 8601 timestamp
}

/// Human-readable insight derived from style analysis for dashboard display
class StyleInsight {
  category string                 // tone, structure, vocabulary, rhetoric
  insight string                  // Human-readable observation (e.g., "You prefer warmer greetings")
  evidence string[]               // Example phrases/corrections supporting this insight
  confidence float                // 0-1, confidence in this specific insight
}

// -----------------------------------------------------------------------------
// Request/Response Types for Style Analysis
// -----------------------------------------------------------------------------

/// Correction pair for batch analysis
class CorrectionPair {
  originalContent string          // AI-generated content before coach edit
  editedContent string            // Coach's edited version
  editType EditType               // Severity of edit
  coachFeedback CoachFeedback?    // Explicit feedback if provided
  contentType VoiceContentType?   // Type of content being edited
  timestamp string                // ISO 8601 timestamp of correction
}

/// Request for batch style analysis
class StyleAnalysisRequest {
  coachId int
  correctionPairs CorrectionPair[]
  existingProfile StyleAnalysis?  // Previous profile to refine
  includeInsights bool            // Whether to generate human-readable insights
}

/// Response from style analysis
class StyleAnalysisResponse {
  styleProfile StyleAnalysis
  insights StyleInsight[]?        // Human-readable insights if requested
  voiceMatchConfidence float      // Estimated content match rate after this analysis
  improvementSuggestions string[] // Suggestions for better voice matching
}

// -----------------------------------------------------------------------------
// Extended Voice Profile (v1)
// -----------------------------------------------------------------------------

/// Extended voice profile with v1 style analysis
/// Extends the base VoiceProfile with LLM-computed style data
class VoiceProfileV1 {
  coachId int
  voiceConfidence float           // Overall voice matching confidence 0-1
  totalCorrections int
  vocabularyPatterns string[]     // v0: word-level patterns
  avoidPatterns string[]          // v0: words/phrases to avoid
  tonePreferences TonePreference[] // v0: explicit tone preferences
  recentEdits VoiceCorrection[]   // Recent corrections for context
  lastTrainedAt string?           // When v0 patterns were last updated

  // v1 additions
  styleAnalysis StyleAnalysis?    // LLM-computed style profile
  styleInsights StyleInsight[]?   // Human-readable insights
  analysisVersion string          // Version of analysis algorithm (e.g., "v1.0")
  lastAnalyzedAt string?          // When style analysis was last run
}

// -----------------------------------------------------------------------------
// Voice Matching Types
// -----------------------------------------------------------------------------

/// Result of scoring content against voice profile
class VoiceMatchResult {
  overallScore float              // 0-1 composite score
  toneScore float                 // How well tone matches profile
  structureScore float            // How well sentence structure matches
  vocabularyScore float           // How well vocabulary matches
  breakdown map<string, float>    // Detailed dimension scores
  suggestions string[]            // Specific suggestions for improvement
}

/// Coach's manual style tuning adjustments
class StyleTuning {
  toneAdjustments ToneVector?     // Manual tone preference adjustments
  addPhrases string[]             // Phrases coach wants system to use more
  removePhrases string[]          // Phrases coach wants system to avoid
  notes string?                   // Coach's notes on their style preferences
}

// -----------------------------------------------------------------------------
// Dashboard Data Types
// -----------------------------------------------------------------------------

/// Data for the style analysis dashboard
class StyleDashboardData {
  profile VoiceProfileV1
  trendData StyleTrendPoint[]     // Historical confidence/correction data
  topInsights StyleInsight[]      // Most significant insights (top 5)
  recentCorrections VoiceCorrection[] // Recent corrections for review
  improvementAreas string[]       // Areas where voice matching can improve
}

/// Single data point for style trend chart
class StyleTrendPoint {
  date string                     // ISO 8601 date
  voiceConfidence float           // Confidence at this point
  correctionsCount int            // Corrections submitted that day
  avgMatchScore float?            // Average voice match score if available
}

// -----------------------------------------------------------------------------
// BAML Function Definitions
// -----------------------------------------------------------------------------

/// Analyze correction pairs to compute style profile
function AnalyzeStyleFromCorrections(request: StyleAnalysisRequest) -> StyleAnalysisResponse {
  client GroqNormal
  prompt #"
    Analyze these writing corrections to understand the coach's unique communication style.

    For each correction pair, identify:
    1. Tone adjustments (warmer/cooler, formal/casual, direct/indirect)
    2. Sentence structure preferences (length, complexity, rhythm)
    3. Rhetorical patterns (questions, affirmations, challenges, reflections)
    4. Emotional register (empathy level, energy level)
    5. Specific phrases added/removed and the underlying preference

    {{ _.role("user") }}
    Correction pairs to analyze:
    {% for pair in request.correctionPairs %}
    ---
    Original: {{ pair.originalContent }}
    Edited: {{ pair.editedContent }}
    Edit type: {{ pair.editType }}
    {% if pair.coachFeedback %}Feedback: {{ pair.coachFeedback }}{% endif %}
    ---
    {% endfor %}

    {% if request.existingProfile %}
    Previous style profile to refine:
    {{ request.existingProfile }}
    {% endif %}

    Respond with ONLY a valid JSON object (no markdown, no explanation) matching this exact schema:
    {
      "styleProfile": {
        "toneProfile": {"warmth": <float -1 to 1>, "formality": <float -1 to 1>, "directness": <float -1 to 1>, "empathy": <float 0 to 1>, "energy": <float -1 to 1>},
        "sentencePatterns": ["<string>"],
        "transitionPhrases": ["<string>"],
        "emotionalRegister": "<string describing overall tone>",
        "rhetoricalPatterns": ["<string>"],
        "confidence": <float 0 to 1>,
        "sampleCount": {{ request.correctionPairs | length }},
        "lastUpdated": "2026-01-21T00:00:00Z"
      },
      "insights": [{"category": "<string>", "insight": "<string>", "evidence": ["<string>"], "confidence": <float>}],
      "voiceMatchConfidence": <float 0 to 1>,
      "improvementSuggestions": ["<string>"]
    }
  "#
}

/// Score content against voice profile
function ScoreVoiceMatch(content: string, profile: VoiceProfileV1) -> VoiceMatchResult {
  client GroqNormal
  prompt #"
    Score how well this content matches the coach's voice profile.

    {{ _.role("user") }}
    Content to score:
    {{ content }}

    Voice profile:
    - Tone: {{ profile.styleAnalysis.toneProfile }}
    - Sentence patterns: {{ profile.styleAnalysis.sentencePatterns }}
    - Transition phrases: {{ profile.styleAnalysis.transitionPhrases }}
    - Emotional register: {{ profile.styleAnalysis.emotionalRegister }}
    - Vocabulary to use: {{ profile.vocabularyPatterns }}
    - Vocabulary to avoid: {{ profile.avoidPatterns }}

    Provide:
    1. Overall score 0-1
    2. Tone match score
    3. Structure match score
    4. Vocabulary match score
    5. Detailed breakdown
    6. Specific suggestions for improvement
  "#
}

/// Generate style insights from profile for dashboard
function GenerateStyleInsights(profile: VoiceProfileV1) -> StyleInsight[] {
  client GroqNormal
  prompt #"
    Generate human-readable insights about this coach's writing style.

    {{ _.role("user") }}
    Voice profile data:
    - Tone profile: {{ profile.styleAnalysis.toneProfile }}
    - Sentence patterns: {{ profile.styleAnalysis.sentencePatterns }}
    - Rhetorical patterns: {{ profile.styleAnalysis.rhetoricalPatterns }}
    - Vocabulary preferences: {{ profile.vocabularyPatterns }}
    - Avoid patterns: {{ profile.avoidPatterns }}
    - Total corrections: {{ profile.totalCorrections }}

    Generate 3-5 actionable insights that help the coach understand what the system
    has learned about their style. Each insight should:
    - Be clear and specific
    - Include evidence from the data
    - Have a confidence level
    - Be categorized (tone, structure, vocabulary, rhetoric)
  "#
}
