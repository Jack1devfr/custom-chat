# Chat Custom GitHub updater
# Run in PowerShell: .\update-chat-custom.ps1
# This downloads the latest published GitHub Release and updates an existing
# Load unpacked folder. It never runs JavaScript downloaded outside the extension.

$ErrorActionPreference = "Stop"
$Repo = "Jack1devfr/custom-chat"
$Api = "https://api.github.com/repos/$Repo/releases/latest"

Write-Host "Chat Custom updater" -ForegroundColor Cyan
$Target = Read-Host "Paste the FULL folder path selected in chrome://extensions (the folder containing manifest.json)"
$Target = $Target.Trim('"').Trim()
if (-not (Test-Path -LiteralPath (Join-Path $Target "manifest.json"))) {
    throw "That folder does not contain manifest.json. No files were changed."
}

$Current = Get-Content -Raw -LiteralPath (Join-Path $Target "manifest.json") | ConvertFrom-Json
Write-Host "Installed version: $($Current.version)"

$Headers = @{ "Accept" = "application/vnd.github+json"; "User-Agent" = "Chat-Custom-Updater" }
$Release = Invoke-RestMethod -Uri $Api -Headers $Headers
$Asset = $Release.assets | Where-Object { $_.name -like "chat-custom-*.zip" } | Select-Object -First 1
if (-not $Asset) { throw "The latest GitHub Release has no chat-custom ZIP asset yet." }

$Temp = Join-Path $env:TEMP ("chat-custom-update-" + [guid]::NewGuid().ToString("N"))
$Zip = Join-Path $Temp $Asset.name
$Extract = Join-Path $Temp "extracted"
New-Item -ItemType Directory -Path $Extract -Force | Out-Null
try {
    Invoke-WebRequest -Uri $Asset.browser_download_url -OutFile $Zip -Headers @{ "User-Agent" = "Chat-Custom-Updater" }
    Expand-Archive -LiteralPath $Zip -DestinationPath $Extract -Force

    $NewManifestPath = Join-Path $Extract "manifest.json"
    if (-not (Test-Path -LiteralPath $NewManifestPath)) { throw "Downloaded package is missing manifest.json." }
    $New = Get-Content -Raw -LiteralPath $NewManifestPath | ConvertFrom-Json
    if ($New.manifest_version -ne 3 -or $New.name -ne "Chat Custom") {
        throw "Downloaded package did not pass extension identity/Manifest V3 checks."
    }
    if ([version]$New.version -le [version]$Current.version) {
        Write-Host "No newer version found. GitHub latest is $($New.version)." -ForegroundColor Yellow
        return
    }

    $Backup = "$Target.backup-$(Get-Date -Format yyyyMMdd-HHmmss)"
    Copy-Item -LiteralPath $Target -Destination $Backup -Recurse
    Get-ChildItem -LiteralPath $Extract -Force | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $Target -Recurse -Force
    }
    Write-Host "Updated Chat Custom to $($New.version)." -ForegroundColor Green
    Write-Host "Backup: $Backup"
    Write-Host "Now open chrome://extensions and click Reload on Chat Custom."
    Start-Process "chrome://extensions"
}
finally {
    Remove-Item -LiteralPath $Temp -Recurse -Force -ErrorAction SilentlyContinue
}
