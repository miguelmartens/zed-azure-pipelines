; textobjects.scm - Text objects for Azure Pipelines YAML files.
; These queries enable users to select and navigate through structural elements in the file.

; Select an entire mapping pair (key-value) as a function-like text object.
(pair) @function.around

; Select only the value part of a mapping pair for inner selection.
(pair value: _) @function.inside

; Optionally, select block scalars as a distinct text object.
(block_scalar) @block.inside
