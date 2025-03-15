# Zed Azure Pipelines Extension

This extension brings Azure Pipelines language support to the [Zed Editor](https://zed.dev/). It integrates the [Azure Pipelines Language Server](https://www.npmjs.com/package/azure-pipelines-language-server) to provide rich language features like syntax highlighting, code completions, and diagnostics for Azure Pipelines YAML files.

> **Note:** This extension is inspired by the [zed-ansible](https://github.com/kartikvashistha/zed-ansible/tree/main) extension as well as the official [Azure Pipelines VS Code extension](https://github.com/Microsoft/azure-pipelines-vscode).
> **Important:** The extension currently only works when an Azure Pipelines file is detected as a YAML file, due to the absence of a dedicated Azure Pipelines grammar. It leverages the [tree-sitter-yaml](https://github.com/tree-sitter-grammars/tree-sitter-yaml) grammar until a specialized one is developed.

## Features

- **Azure Pipelines Language Support:** Leverages the azure-pipelines-language-server to offer intellisense and error checking for Azure Pipelines files.
- **Automatic Package Management:** Checks for the language server package and installs/updates it as needed.
- **Workspace Configuration:** Customizes LSP settings per workspace.
- **YAML-based Parsing:** Currently leverages the YAML grammar for syntax highlighting and Tree-sitter features [tree-sitter-yaml](https://github.com/tree-sitter/tree-sitter-yaml).

## Installation

1. **Clone or Download** the repository:
   ```sh
   git clone https://github.com/miguelmartens/zed-azure-pipelines.git
   ```
2. **Build the Extension:**
   Make sure you have [Rust](https://www.rust-lang.org/tools/install) installed via `rustup`. Then build the extension for WebAssembly:
   ```sh
   cargo build --release --target wasm32-unknown-unknown
   ```
3. **Install in Zed:**
   Open Zed Editor, go to the Extensions page, click **Install Dev Extension**, and select your extension's directory. (If a published version exists, the dev extension will override it.)

## Configuration

For the best experience, update your global Zed settings.

### File Types

By default, the Azure Pipelines Language Server attaches to files recognized as Azure Pipelines YAML files. Since full glob pattern matching isn’t directly handled by the extension, it’s recommended to add the following configuration under the `file_types` section of your Zed settings:

```json
"file_types": {
    "Azure Pipelines": [
        "**.azure-pipelines.yml",
        "**.azure-pipelines.yaml",
        "**/azure-pipelines.yml",
        "**/azure-pipelines.yaml",
        "**/.azure-pipelines/**.yml",
        "**/.azure-pipelines/**.yaml",
        "**/pipelines/**.yml",
        "**/pipelines/**.yaml",
        "**/pipeline-templates/**.yml",
        "**/pipeline-templates/**.yaml"
    ]
}
```

### LSP Configuration

Add the following under your `lsp` settings to fine-tune the language server experience:

```json
"lsp": {
  "azure-pipelines-language-server": {
    "settings": {
      "azurePipelines": {
        "validation": {
          "enabled": true
        },
        "executionEnvironment": {
          "enabled": false
        }
      }
    }
  }
}
```

*Note:* The extension wraps your configuration under the `"azurePipelines"` key automatically, allowing you to keep your settings clean.

## How It Works

The extension uses the Zed Extension API to:
- **Check and Install:** Verify if the Azure Pipelines language server exists at the expected path, and install/update it using npm if necessary.
- **Launch the LSP:** Constructs the command to launch the language server via Node.js (using the system’s Node binary).
- **Pass Settings:** Merges any workspace-specific LSP settings for a tailored experience.

## License

This project is licensed under the MIT License.
