#!/bin/bash
set -e

CLAUDE_DIR="$HOME/.claude"

echo "Uninstalling claude-robot-voice..."

# Remove scripts
rm -f "$CLAUDE_DIR/speak_progress.sh"
rm -f "$CLAUDE_DIR/speak_thinking.sh"
echo "  ✓ Removed speak scripts"

# Remove hooks from settings.json
python3 - "$CLAUDE_DIR/settings.json" <<'PYEOF'
import json, sys, os

settings_path = sys.argv[1]
if not os.path.exists(settings_path):
    print("  ✓ Nothing to remove from settings.json")
    sys.exit(0)

with open(settings_path) as f:
    existing = json.load(f)

hooks = existing.get("hooks", {})
hooks.pop("PreToolUse", None)
hooks.pop("PostToolUse", None)
if not hooks:
    existing.pop("hooks", None)
else:
    existing["hooks"] = hooks

with open(settings_path, "w") as f:
    json.dump(existing, f, indent=2)
    f.write("\n")

print("  ✓ Removed hooks from ~/.claude/settings.json")
PYEOF

echo ""
echo "Uninstalled. Claude is now silent and sad. 🤖"
