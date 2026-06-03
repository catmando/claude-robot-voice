#!/bin/bash
# Installs claude-robot-voice into ~/.claude/
# Speaks a funny phrase when Claude needs your input (AskUserQuestion or tool approval).

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

if [[ "$(uname)" != "Darwin" ]]; then
  echo "Sorry, this requires macOS (uses the 'say' command)."
  exit 1
fi

mkdir -p "$CLAUDE_DIR"

echo "Installing claude-robot-voice..."

cp "$SCRIPT_DIR/speak_waiting.sh" "$CLAUDE_DIR/speak_waiting.sh"
cp "$SCRIPT_DIR/speak_reset_timer.sh" "$CLAUDE_DIR/speak_reset_timer.sh"
chmod +x "$CLAUDE_DIR/speak_waiting.sh" "$CLAUDE_DIR/speak_reset_timer.sh"
echo "  ✓ Installed speak_waiting.sh"
echo "  ✓ Installed speak_reset_timer.sh"

# Merge hooks into settings.json using Ruby
ruby - "$SETTINGS" "$CLAUDE_DIR/speak_waiting.sh" <<'RUBY'
require 'json'

settings_path = ARGV[0]
script_path   = ARGV[1]

settings = File.exist?(settings_path) ? JSON.parse(File.read(settings_path)) : {}
settings["hooks"] ||= {}

hook_entry = { "type" => "command", "command" => script_path }

# AskUserQuestion fires via PreToolUse with matcher
settings["hooks"]["PreToolUse"] ||= []
unless settings["hooks"]["PreToolUse"].any? { |e| e["matcher"] == "AskUserQuestion" && e["hooks"]&.any? { |h| h["command"] == script_path } }
  settings["hooks"]["PreToolUse"] << { "matcher" => "AskUserQuestion", "hooks" => [hook_entry] }
end

# PermissionRequest fires its own event
settings["hooks"]["PermissionRequest"] ||= []
unless settings["hooks"]["PermissionRequest"].any? { |e| e["hooks"]&.any? { |h| h["command"] == script_path } }
  settings["hooks"]["PermissionRequest"] << { "hooks" => [hook_entry] }
end

# UserPromptSubmit resets the cooldown timer when the user responds
reset_path = File.join(File.dirname(script_path), "speak_reset_timer.sh")
reset_entry = { "type" => "command", "command" => reset_path }
settings["hooks"]["UserPromptSubmit"] ||= []
unless settings["hooks"]["UserPromptSubmit"].any? { |e| e["hooks"]&.any? { |h| h["command"] == reset_path } }
  settings["hooks"]["UserPromptSubmit"] << { "hooks" => [reset_entry] }
end

File.write(settings_path, JSON.pretty_generate(settings) + "\n")
RUBY

echo "  ✓ Hooks added to ~/.claude/settings.json"
echo ""
echo "To set a voice for a project, create .claude/stop-messages.yml in your project root."
echo "See stop-messages.yml.example for the format."
echo ""
echo "Done! Claude will now speak when it needs your input."
