; indents.scm - Indentation rules for Azure Pipelines YAML files in Zed Editor.
; These rules help determine when the editor should automatically increase indentation.

; Increase indent for arrays and mappings when their closing delimiter is encountered.
(array "]" @end) @indent
(object "}" @end) @indent

; Increase indent for block mapping pairs where the key indicates a nested structure.
; Common Azure Pipelines keys that introduce nested content include:
;   - jobs
;   - steps
;   - variables
;   - pool
(
  (block_mapping_pair
    key: (plain_scalar) @key)
  (#match? @key "^(jobs|steps|variables|pool)$")
) @indent
