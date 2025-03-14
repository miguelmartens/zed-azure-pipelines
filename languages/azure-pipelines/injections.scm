; injections.scm - Injection rules for Azure Pipelines YAML files.
; This file defines rules to detect and inject language-specific highlighting in embedded code
; within Azure Pipelines files.

; Generic rule for fenced code blocks.
(fenced_code_block
  (info_string (plain_scalar) @injection.language)
  (code_fence_content) @injection.content)

; Rule for inline script blocks.
; This targets mapping pairs where the key is "script" and the value is a block scalar.
; It sets the injection language to "bash" (or adjust to "powershell" if needed).
(
  (pair
    key: (plain_scalar) @_key (#eq? @_key "script")
    value: (block_scalar) @injection.content)
  (#set! injection.language "bash")
)
