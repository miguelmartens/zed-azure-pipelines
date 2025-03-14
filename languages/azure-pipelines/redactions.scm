; Redaction rules for Azure Pipelines YAML files.
; This query marks the value of mapping pairs to be redacted.
(block_mapping_pair value: (flow_node) @redact)
