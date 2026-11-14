# Chat Custom

Manifest V3 Chrome extension for https://www.polybuzz.ai/.

## Features
- Configurable ad-hiding selectors in rules.json.
- MutationObserver rescans for dynamically inserted ad elements.
- Custom image or solid-color backgrounds.
- Background opacity, image fit, and position controls.
- Preferences stored in chrome.storage.local.
- Chat Custom logo and extension icons.

## Install locally
1. Download and extract the release ZIP.
2. Open chrome://extensions.
3. Enable Developer mode.
4. Select Load unpacked and choose this folder.

## Updates
For automatic Chrome updates, publish the extension through the Chrome Web Store (Unlisted is an option) and publish subsequent versions to the same listing. Chrome handles update delivery. GitHub Actions can package tagged releases and publish to the Web Store using credentials stored only in GitHub Actions Secrets.

Unpacked developer installs do not auto-update from GitHub; pull the latest code and reload the extension manually.

## Security
- Do not fetch or execute JavaScript from GitHub at runtime. Manifest V3 requires executable extension code to ship inside the package.
- Protect release tags and restrict publishing workflows to trusted maintainers.
- Never commit Web Store refresh tokens, client secrets, or API credentials.

## Source
https://github.com/Jack1devfr/custom-chat