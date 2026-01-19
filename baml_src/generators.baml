// =============================================================================
// BAML Generators Configuration
// =============================================================================
// This file configures code generation for Python and TypeScript clients.
// Generated code is written directly into package source trees.
//
// IMPORTANT: Generated code is never hand-edited.
// =============================================================================

// Python/Pydantic generator for backend consumption
generator python {
  output_type "python/pydantic"
  output_dir "../packages/python/src/coach_app_baml_client"
  version "0.217.0"
}

// TypeScript generator for frontend consumption
generator typescript {
  output_type "typescript"
  output_dir "../packages/typescript/src"
  version "0.217.0"
}
