; Outline query for Azure Pipelines YAML files.
; This query captures mapping keys (from block mapping pairs) and marks them as outline items.
(block_mapping_pair key: (flow_node (plain_scalar (string_scalar) @title))) @item
