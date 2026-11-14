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

## Update manually (no updater script needed)
You can update Chat Custom yourself whenever a new GitHub Release is available:
1. Open https://github.com/Jack1devfr/custom-chat/releases/latest.
2. Download the `chat-custom-vX.Y.Z.zip` asset.
3. Extract the ZIP into a new temporary folder.
4. Open `chrome://extensions` and find Chat Custom.
5. Use the extension's Details page to confirm the folder location if needed. Replace the files in the existing unpacked extension folder with the files from the ZIP. Do not delete the extension or choose Remove.
6. Return to `chrome://extensions` and click Reload on Chat Custom.

Keep the same unpacked extension folder and do not remove/re-add the extension. This helps preserve its extension identity and settings in `chrome.storage.local`. Close any open PolyBuzz tabs and reopen them if the page does not reflect the update immediately.

## Update with the optional PowerShell helper
If you prefer, download `update-chat-custom.ps1` from this repository, run it in PowerShell, and paste the full path to the existing unpacked extension folder. It downloads the latest public GitHub Release ZIP, checks the extension name and Manifest V3, backs up the installed folder, and copies the new files. Then click Reload at `chrome://extensions`.

Both update methods require a manual click on Reload because Chrome does not let an unpacked extension silently replace its running code. Neither method requires the Chrome Web Store.

## Publishing a release
Update `manifest.json` to a new version, commit the changes, then create and push a matching tag (for example, version 1.1.1 uses tag `v1.1.1`). GitHub Actions packages the extension and attaches the ZIP to a GitHub Release. Both update methods use that release ZIP.

## Security
- The helper downloads a ZIP from this repository's GitHub Releases.
- It validates the package manifest before copying files and creates a timestamped backup.
- It does not execute JavaScript from GitHub as an updater process.
- Do not commit passwords, access tokens, or publishing secrets.

## Source
https://github.com/Jack1devfr/custom-chat
