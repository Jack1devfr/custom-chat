# Chat Custom

Manifest V3 Chrome extension for https://www.polybuzz.ai/.

## Features
- Configurable ad-hiding selectors in rules.json.
- MutationObserver rescans for dynamically inserted ad elements.
- Custom image or solid-color backgrounds.
- Background opacity, image fit, and position controls.
- Preferences stored in chrome.storage.local.
- Chat Custom logo.

## Install locally
1. Download and extract a release ZIP.
2. Open chrome://extensions and enable Developer mode.
3. Choose Load unpacked and select the extracted extension folder.

## Update without the Chrome Web Store
This project supports a user-run PowerShell updater for unpacked installations:
1. Download update-chat-custom.ps1 from the repository.
2. Run it in PowerShell.
3. Paste the full folder path selected with Load unpacked (the folder containing manifest.json).
4. The updater downloads the latest public GitHub Release ZIP, checks the extension name and Manifest V3, backs up the installed folder, and copies the new files.
5. Open chrome://extensions and click Reload on Chat Custom.

The updater does not silently install or execute remote code. Chrome still requires the user to reload an unpacked extension. Preferences stored in chrome.storage.local remain in Chrome's extension storage when the same unpacked extension identity/folder is retained. Avoid removing and re-adding the extension.

## Publishing a release
Update manifest.json to a new version, commit the changes, then create and push a matching tag (for example, version 1.1.1 uses tag v1.1.1). GitHub Actions packages the extension and attaches the ZIP to a GitHub Release. The updater reads the latest published release.

## Security
- The updater only downloads a ZIP from this repository's GitHub Releases.
- It validates the package manifest before copying files and creates a timestamped backup.
- It does not execute JavaScript from GitHub as an updater process.
- Do not commit passwords, access tokens, or publishing secrets.

## Source
https://github.com/Jack1devfr/custom-chat
