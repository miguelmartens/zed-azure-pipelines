; Bracket matching rules for Azure Pipelines files.
; These rules match common delimiters used in YAML and Azure Pipelines configurations.
("[" @open "]" @close)
("{" @open "}" @close)
("\"" @open "\"" @close)
