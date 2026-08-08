#!/usr/bin/env bash
# ==============================================================================
# publish.sh — one-command publish for macOS / Linux
#
# Usage:
#   ./scripts/publish.sh                        # auto-detects the latest binder-qa report in ~/Downloads
#   ./scripts/publish.sh "sprint-42-regression" # renames with the given label
#
# What it does:
#   1. Finds the latest binder-qa report in ~/Downloads
#   2. Moves it to qa-reports/ with an optional cleaner label
#   3. Commits and pushes
# ==============================================================================

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}==> Binder QA report publisher${NC}"

# Check we're in the right directory
if [ ! -d "qa-reports" ]; then
  echo -e "${RED}Error: qa-reports/ folder not found. Run this script from the binder-qa project root.${NC}"
  exit 1
fi

# Check git is initialized
if [ ! -d ".git" ]; then
  echo -e "${RED}Error: not a git repository. Run 'git init' first, or clone the repo.${NC}"
  exit 1
fi

# Find latest binder-qa report in Downloads
DOWNLOADS="${HOME}/Downloads"
if [ ! -d "$DOWNLOADS" ]; then
  echo -e "${RED}Error: Downloads folder not found at $DOWNLOADS${NC}"
  exit 1
fi

LATEST=$(ls -t "$DOWNLOADS"/binder-qa-*.html 2>/dev/null | head -n 1 || true)

if [ -z "$LATEST" ]; then
  echo -e "${RED}Error: no binder-qa-*.html files found in $DOWNLOADS${NC}"
  echo -e "${YELLOW}   Generate a report from the QA tool first, then run this script again.${NC}"
  exit 1
fi

BASENAME=$(basename "$LATEST")
echo -e "${GREEN}==> Found: $BASENAME${NC}"

# Rename if a label provided
LABEL="$1"
if [ -n "$LABEL" ]; then
  TODAY=$(date +%Y-%m-%d)
  # Sanitize label
  CLEAN_LABEL=$(echo "$LABEL" | tr ' ' '-' | tr -c 'a-zA-Z0-9-' '-' | tr -s '-' | sed 's/^-\|-$//g')
  NEW_NAME="${CLEAN_LABEL}-${TODAY}.html"
  echo -e "${BLUE}==> Renaming to: $NEW_NAME${NC}"
else
  NEW_NAME="$BASENAME"
fi

DEST="qa-reports/$NEW_NAME"

# Check if the destination file already exists
if [ -f "$DEST" ]; then
  echo -e "${YELLOW}==> Warning: $DEST already exists.${NC}"
  read -p "Overwrite? [y/N] " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}Aborted.${NC}"
    exit 1
  fi
fi

# Move file
mv "$LATEST" "$DEST"
echo -e "${GREEN}==> Moved to: $DEST${NC}"

# Git add + commit + push
COMMIT_MSG="QA report: ${LABEL:-$(basename "$NEW_NAME" .html)}"
echo -e "${BLUE}==> Committing: $COMMIT_MSG${NC}"

git add "$DEST"
git commit -m "$COMMIT_MSG"

echo -e "${BLUE}==> Pushing to remote...${NC}"
git push

# Get remote URL to construct GitHub Pages URL
REMOTE_URL=$(git remote get-url origin 2>/dev/null || echo "")

if [[ "$REMOTE_URL" =~ github\.com[:/]([^/]+)/([^/.]+) ]]; then
  USER="${BASH_REMATCH[1]}"
  REPO="${BASH_REMATCH[2]}"
  PAGES_URL="https://${USER}.github.io/${REPO}/qa-reports/${NEW_NAME}"

  echo ""
  echo -e "${GREEN}==> Published!${NC}"
  echo -e "${YELLOW}==> Wait 30-60 seconds for GitHub Pages to rebuild, then share this URL:${NC}"
  echo ""
  echo -e "    ${GREEN}${PAGES_URL}${NC}"
  echo ""

  # Try to copy to clipboard (macOS)
  if command -v pbcopy &> /dev/null; then
    echo "$PAGES_URL" | pbcopy
    echo -e "${BLUE}   (URL copied to clipboard)${NC}"
  elif command -v xclip &> /dev/null; then
    echo "$PAGES_URL" | xclip -selection clipboard
    echo -e "${BLUE}   (URL copied to clipboard)${NC}"
  fi
else
  echo -e "${GREEN}==> Done. Push complete.${NC}"
fi
