; overrides.scm - Syntax overrides for Azure Pipelines YAML files.
; These rules adjust certain editor behaviors for improved editing in Azure Pipelines files.

; Make string ranges inclusive so that features (like auto-completion) work correctly when the cursor is inside a string.
(string) @string.inclusive

; Disable auto-closing of quotes when inside a string to prevent extra characters from being inserted.
(string) @string.no_autoclose

; Optionally, disable auto-closing for block scalars (often used for multi-line scripts).
(block_scalar) @string.no_autoclose
