#!/bin/bash
# Removes claude-robot-voice hooks and script from ~/.claude/

CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"
SCRIPT="$CLAUDE_DIR/speak_waiting.sh"

echo "Uninstalling claude-robot-voice..."

rm -f "$SCRIPT" "${SCRIPT%speak_waiting.sh}speak_reset_timer.sh"
echo "  ✓ Removed speak_waiting.sh and speak_reset_timer.sh"

if [ -f "$SETTINGS" ]; then
  ruby - "$SETTINGS" "$SCRIPT" <<'RUBY'
require 'json'

settings_path = ARGV[0]
script_path   = ARGV[1]

settings = JSON.parse(File.read(settings_path))
hooks = settings["hooks"] || {}

reset_path = File.join(File.dirname(script_path), "speak_reset_timer.sh")
hooks["PreToolUse"]&.reject! { |e| e["hooks"]&.any? { |h| h["command"] == script_path } }
hooks["PermissionRequest"]&.reject! { |e| e["hooks"]&.any? { |h| h["command"] == script_path } }
hooks["UserPromptSubmit"]&.reject! { |e| e["hooks"]&.any? { |h| h["command"] == reset_path } }

hooks.delete_if { |_, v| v.empty? }
settings["hooks"] = hooks
settings.delete("hooks") if hooks.empty?

File.write(settings_path, JSON.pretty_generate(settings) + "\n")
RUBY
  echo "  ✓ Removed hooks from ~/.claude/settings.json"
fi

echo ""
echo "Uninstalled. Claude is silent again."
