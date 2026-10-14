# Senpi cat-jam-free Patch

Patches the `@code-yeongyu/senpi` bundle to add `cat-jam-free` to the `opencode-go` provider catalog.

## Problem

Senpi's hardcoded model catalog is outdated. It includes `cat-jam-free` under the `opencode` (Zen) provider but **not** under `opencode-go`, even though the [OpenCode Go API](https://opencode.ai/docs/go/) supports it. This causes OMO to fall back to `longcat` when `opencode-go/cat-jam-free` is configured.

## Solution

This repo contains a patch script that inserts `cat-jam-free` into the `opencode-go` catalog in Senpi's bundle files.

## Usage

```bash
# Auto-detect Senpi installation
./patch.sh

# Or specify the path manually
./patch.sh ~/.bun/install/global/node_modules/@code-yeongyu/senpi
```

After running, restart your OMO/Senpi session.

## Re-apply after update

When Senpi updates (e.g. `bun update`), the patch is overwritten. Re-run:

```bash
./patch.sh
```

## What it patches

| File | Change |
|------|--------|
| `dist/bundle/chunks/chunk-NNQ7DPUD.js` | Adds `cat-jam-free` model to `opencode-go` catalog |
| `dist/bundle/chunks/session-worker.js` | Same |

## Model details

- **ID**: `cat-jam-free`
- **Name**: Cat Jam Free
- **Provider**: `opencode-go`
- **API**: `openai-completions`
- **Base URL**: `https://opencode.ai/zen/go/v1`
- **Context**: 262,144 tokens
- **Max tokens**: 131,072
- **Cost**: Free (limited time)
