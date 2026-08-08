# ==============================================================================
# publish.ps1 — one-command publish for Windows PowerShell
#
# Usage:
#   .\scripts\publish.ps1
#   .\scripts\publish.ps1 "sprint-42-regression"
#
# What it does:
#   1. Finds the latest binder-qa report in Downloads
#   2. Moves it to qa-reports/ with an optional cleaner label
#   3. Commits and pushes
# ==============================================================================

param(
    [string]$Label = ""
)

# Colors via Write-Host
function Write-Info    { param($m) Write-Host "==> $m" -ForegroundColor Blue }
function Write-Success { param($m) Write-Host "==> $m" -ForegroundColor Green }
function Write-Warn    { param($m) Write-Host "==> $m" -ForegroundColor Yellow }
function Write-Err     { param($m) Write-Host "==> $m" -ForegroundColor Red }

Write-Info "Binder QA report publisher"

# Check we are in the right directory
if (-not (Test-Path "qa-reports")) {
    Write-Err "qa-reports\ folder not found. Run this script from the binder-qa project root."
    exit 1
}

# Check git is initialized
if (-not (Test-Path ".git")) {
    Write-Err "Not a git repository. Run 'git init' first, or clone the repo."
    exit 1
}

# Find the latest binder-qa report in Downloads
$Downloads = Join-Path $env:USERPROFILE "Downloads"
if (-not (Test-Path $Downloads)) {
    Write-Err "Downloads folder not found at $Downloads"
    exit 1
}

$Latest = Get-ChildItem "$Downloads\binder-qa-*.html" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $Latest) {
    Write-Err "No binder-qa-*.html files found in $Downloads"
    Write-Warn "Generate a report from the QA tool first, then run this script again."
    exit 1
}

Write-Success "Found: $($Latest.Name)"

# Rename if a label provided
if ($Label) {
    $Today = Get-Date -Format "yyyy-MM-dd"
    $CleanLabel = ($Label -replace '\s+', '-' -replace '[^a-zA-Z0-9-]', '-' -replace '-+', '-').Trim('-')
    $NewName = "$CleanLabel-$Today.html"
    Write-Info "Renaming to: $NewName"
} else {
    $NewName = $Latest.Name
}

$Dest = "qa-reports\$NewName"

# Check if destination exists
if (Test-Path $Dest) {
    Write-Warn "$Dest already exists."
    $Confirm = Read-Host "Overwrite? [y/N]"
    if ($Confirm -ne 'y' -and $Confirm -ne 'Y') {
        Write-Err "Aborted."
        exit 1
    }
}

# Move file
Move-Item $Latest.FullName $Dest -Force
Write-Success "Moved to: $Dest"

# Git add + commit + push
$CommitMsg = if ($Label) { "QA report: $Label" } else { "QA report: $([System.IO.Path]::GetFileNameWithoutExtension($NewName))" }
Write-Info "Committing: $CommitMsg"

git add $Dest
git commit -m $CommitMsg

Write-Info "Pushing to remote..."
git push

# Try to construct the GitHub Pages URL
$RemoteUrl = git remote get-url origin 2>$null

if ($RemoteUrl -match 'github\.com[:/]([^/]+)/([^/.]+)') {
    $User = $Matches[1]
    $Repo = $Matches[2]
    $PagesUrl = "https://$User.github.io/$Repo/qa-reports/$NewName"

    Write-Host ""
    Write-Success "Published!"
    Write-Warn "Wait 30-60 seconds for GitHub Pages to rebuild, then share this URL:"
    Write-Host ""
    Write-Host "    $PagesUrl" -ForegroundColor Green
    Write-Host ""

    # Copy to clipboard
    try {
        Set-Clipboard -Value $PagesUrl
        Write-Info "URL copied to clipboard"
    } catch { }
} else {
    Write-Success "Done. Push complete."
}
