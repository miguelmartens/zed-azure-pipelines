; runnables.scm - Runnable code detection for Azure Pipelines YAML files.
; This query identifies script blocks that can be executed as tasks.

(
  ; Match a mapping pair where the key is "script"
  (pair key: (plain_scalar) @_key (#eq? @_key "script"))
  ; And the value is a block scalar (the multi-line script content)
  (pair value: (block_scalar) @run)
)
; Tag this runnable so the editor knows to show a run button.
(#set! tag pipeline-script)
