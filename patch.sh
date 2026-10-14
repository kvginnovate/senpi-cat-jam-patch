#!/bin/bash
# Patch Senpi bundle to add cat-jam-free to the opencode-go provider catalog
# Senpi's hardcoded model catalog is outdated and missing cat-jam-free under opencode-go
# This script re-applies the patch after any Senpi update

set -euo pipefail

SENPI_DIR="${1:-}"

if [ -z "$SENPI_DIR" ]; then
  # Try to find Senpi installation automatically
  SENPI_DIR=$(find "$HOME/.bun/install/global/node_modules/@code-yeongyu/senpi" \
    -maxdepth 0 -type d 2>/dev/null || true)
fi

if [ -z "$SENPI_DIR" ] || [ ! -d "$SENPI_DIR" ]; then
  echo "ERROR: Senpi installation not found."
  echo "Usage: $0 [path-to-senpi-installation]"
  echo "Example: $0 ~/.bun/install/global/node_modules/@code-yeongyu/senpi"
  exit 1
fi

echo "Patching Senpi at: $SENPI_DIR"

# The anchor text - unique to opencode-go section
ANCHOR='"chat:step-5-preview-free":{id:"step-5-preview-free",name:"Step 5 Preview Free",api:"openai-completions",provider:"opencode-go"'

# The new cat-jam-free model for opencode-go
NEW_MODEL='"chat:cat-jam-free":{id:"cat-jam-free",name:"Cat Jam Free",api:"openai-completions",provider:"opencode-go",baseUrl:"https://opencode.ai/zen/go/v1",reasoning:!0,input:["text"],cost:{input:0,output:0,cacheRead:0,cacheWrite:0},compat:{supportsStore:!1,supportsDeveloperRole:!1,supportsStrictMode:!0,maxTokensField:"max_tokens"},contextWindow:262144,maxTokens:131072,thinkingLevelMap:{off:null,minimal:null,low:"low",medium:"medium",high:"high",xhigh:"xhigh",max:"max"},type:"chat"},'

# Files to patch
FILES=(
  "$SENPI_DIR/dist/bundle/chunks/chunk-NNQ7DPUD.js"
  "$SENPI_DIR/dist/bundle/chunks/session-worker.js"
)

patch_one() {
  local FILE="$1"
  [ -f "$FILE" ] || return 0
  if grep -q 'provider:"opencode-go".*cat-jam-free' "$FILE" 2>/dev/null; then
    echo "Already patched: $FILE"
    return 0
  fi
  [ -f "$FILE.bak" ] || { cp "$FILE" "$FILE.bak"; echo "Backup created: $FILE.bak"; }
  sed -i "s|$ANCHOR|$NEW_MODEL$ANCHOR|g" "$FILE"
  echo "Patched: $FILE"
}

for FILE in "${FILES[@]}"; do
  patch_one "$FILE"
done

for RUNTIME_CHUNKS in "$HOME/.omo/agent/runtime/"*/dist/bundle/chunks; do
  [ -d "$RUNTIME_CHUNKS" ] || continue
  patch_one "$RUNTIME_CHUNKS/chunk-NNQ7DPUD.js"
  patch_one "$RUNTIME_CHUNKS/session-worker.js"
done

echo ""
echo "Done! cat-jam-free added to opencode-go provider."
echo "Restart your OMO/Senpi session to pick up the changes."
