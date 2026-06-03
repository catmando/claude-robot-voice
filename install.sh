#!/bin/bash
set -e

# claude-robot-voice installer
# Gives Claude Code a funny robot voice using macOS say + Claude hooks

CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check we're on macOS
if [[ "$(uname)" != "Darwin" ]]; then
  echo "Sorry, this requires macOS (uses the 'say' command)."
  exit 1
fi

# Check Claude settings file exists
mkdir -p "$CLAUDE_DIR"

echo "Installing claude-robot-voice..."

# Copy scripts
cp "$SCRIPT_DIR/speak_progress.sh" "$CLAUDE_DIR/speak_progress.sh"
cp "$SCRIPT_DIR/speak_thinking.sh" "$CLAUDE_DIR/speak_thinking.sh"
chmod +x "$CLAUDE_DIR/speak_progress.sh"
chmod +x "$CLAUDE_DIR/speak_thinking.sh"

echo "  ✓ Installed speak_progress.sh"
echo "  ✓ Installed speak_thinking.sh"

# Merge hooks into existing settings.json without clobbering other settings
SETTINGS="$CLAUDE_DIR/settings.json"

python3 - "$SETTINGS" "$CLAUDE_DIR" <<'PYEOF'
import json, sys, os

settings_path = sys.argv[1]
claude_dir = sys.argv[2]

# Load existing settings
existing = {}
if os.path.exists(settings_path):
    try:
        with open(settings_path) as f:
            existing = json.load(f)
    except:
        pass

# Build hook entries
hooks = {
    "PreToolUse": [
        {
            "matcher": "",
            "hooks": [
                {
                    "type": "command",
                    "command": os.path.join(claude_dir, "speak_progress.sh")
                }
            ]
        }
    ],
    "PostToolUse": [
        {
            "matcher": "",
            "hooks": [
                {
                    "type": "command",
                    "command": os.path.join(claude_dir, "speak_thinking.sh")
                }
            ]
        }
    ]
}

# Merge — preserve any existing hooks for other events
existing_hooks = existing.get("hooks", {})
existing_hooks.update(hooks)
existing["hooks"] = existing_hooks

with open(settings_path, "w") as f:
    json.dump(existing, f, indent=2)
    f.write("\n")

print("  ✓ Updated ~/.claude/settings.json")
PYEOF

echo ""
echo "All done! BEEP BOOP. Claude will now narrate its work in a robot voice."
echo ""
echo "Voices by task:"
echo "  Git       → Zarvox   (robotic precision)"
echo "  Bash      → Fred     (gruff old-timer)"
echo "  Reading   → Cellos   (dramatic)"
echo "  Writing   → Organ    (grand)"
echo "  Editing   → Bells    (surgical)"
echo "  Searching → Superstar"
echo "  Agents    → Trinoids (alien minion)"
echo "  Thinking  → random weird voice"
echo ""
echo "To uninstall, run: uninstall.sh"
