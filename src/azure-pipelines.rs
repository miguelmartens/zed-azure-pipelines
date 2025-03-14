use std::{env, fs};
use zed_extension_api::{self as zed, serde_json, settings::LspSettings, Result};

const SERVER_PATH: &str = "node_modules/azure-pipelines-language-server/bin/azure-pipelines-language-server";
const PACKAGE_NAME: &str = "azure-pipelines-language-server";

struct AzurePipelinesExtension {
    server_found: bool,
}

impl AzurePipelinesExtension {
    /// Check if the language server binary exists at the expected path.
    fn is_server_present(&self) -> bool {
        fs::metadata(SERVER_PATH).map_or(false, |meta| meta.is_file())
    }

    /// Resolve the path to the language server binary, installing/updating if needed.
    fn resolve_server_path(
        &mut self,
        server_id: &zed::LanguageServerId,
        _worktree: &zed::Worktree,
    ) -> Result<String> {
        let present = self.is_server_present();
        if self.server_found && present {
            return Ok(SERVER_PATH.to_string());
        }

        zed::set_language_server_installation_status(
            server_id,
            &zed::LanguageServerInstallationStatus::CheckingForUpdate,
        );
        let latest_version = zed::npm_package_latest_version(PACKAGE_NAME)?;

        if !present || zed::npm_package_installed_version(PACKAGE_NAME)?
            .as_ref() != Some(&latest_version)
        {
            zed::set_language_server_installation_status(
                server_id,
                &zed::LanguageServerInstallationStatus::Downloading,
            );
            match zed::npm_install_package(PACKAGE_NAME, &latest_version) {
                Ok(()) => {
                    if !self.is_server_present() {
                        return Err(format!(
                            "Package '{}' did not install the expected file at '{}'",
                            PACKAGE_NAME, SERVER_PATH
                        )
                        .into());
                    }
                }
                Err(err) => {
                    if !self.is_server_present() {
                        return Err(err);
                    }
                }
            }
        }

        self.server_found = true;
        Ok(SERVER_PATH.to_string())
    }
}

impl zed::Extension for AzurePipelinesExtension {
    fn new() -> Self {
        Self { server_found: false }
    }

    fn language_server_command(
        &mut self,
        server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command> {
        let resolved_path = self.resolve_server_path(server_id, worktree)?;
        let node_binary = zed::node_binary_path()?;
        // Reverted to original: use unwrap() for current_dir() to avoid conversion issues.
        let full_server_path = env::current_dir()
            .unwrap()
            .join(&resolved_path)
            .to_string_lossy()
            .to_string();
        Ok(zed::Command {
            command: node_binary,
            args: vec![full_server_path, "--stdio".into()],
            env: Default::default(),
        })
    }

    fn language_server_workspace_configuration(
        &mut self,
        _server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<Option<serde_json::Value>> {
        let config = LspSettings::for_worktree("azure-pipelines-language-server", worktree)
            .ok()
            .and_then(|s| s.settings)
            .unwrap_or_default();

        Ok(Some(serde_json::json!({
            "azurePipelines": config
        })))
    }
}

zed::register_extension!(AzurePipelinesExtension);
