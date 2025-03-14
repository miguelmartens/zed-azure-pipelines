; Azure Pipelines syntax highlighting for Zed Editor.
; This file is inspired by the zed-ansible highlights.scm.

; Highlight boolean values.
(boolean_scalar) @boolean

; Highlight null values.
(null_scalar) @constant.builtin

; Highlight strings: double-quoted, single-quoted, block, and plain string scalars.
[
  (double_quote_scalar)
  (single_quote_scalar)
  (block_scalar)
  (string_scalar)
] @string

; Highlight escape sequences within strings.
(escape_sequence) @string.escape

; Highlight numbers: integers and floats.
[
  (integer_scalar)
  (float_scalar)
] @number

; Highlight comments.
(comment) @comment

; Highlight anchors, aliases, and tags.
[
  (anchor_name)
  (alias_name)
  (tag)
] @type

; Capture mapping keys as properties.
key: (flow_node (plain_scalar (string_scalar) @property))

; Optionally, highlight common Azure Pipelines keywords.
((plain_scalar) @keyword (#match? @keyword "^(trigger|pool|jobs|steps|variables)$"))

; Highlight punctuation delimiters.
[
  ","
  "-"
  ":"
  ">"
  "?"
  "|"
] @punctuation.delimiter

; Highlight bracket pairs.
[
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

; Highlight special punctuation.
[
  "*"
  "&"
  "---"
  "..."
] @punctuation.special
