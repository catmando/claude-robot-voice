#!/bin/bash
# Fires on PreToolUse(AskUserQuestion) — Claude needs your input.
# Config: .claude/stop-messages.yml in the project directory.
# Format: voice: VoiceName, phrases: [list]

read -r -d '' INPUT < /dev/stdin 2>/dev/null || true

CONFIG_FILE="$(pwd)/.claude/stop-messages.yml"

if [ -f "$CONFIG_FILE" ]; then
  VOICE=$(ruby -ryaml -e "c=YAML.load_file('$CONFIG_FILE'); puts c['voice']" 2>/dev/null)
  PHRASE=$(ruby -ryaml -e "c=YAML.load_file('$CONFIG_FILE'); puts c['phrases'].sample" 2>/dev/null)
fi

[ -z "$VOICE" ] && VOICE="Zarvox"

if [ -z "$PHRASE" ]; then
  FALLBACKS=(
    "Hey boss, I need your help here"
    "I am the only one working here?"
    "Your move, big shot"
    "Knock knock, anybody home?"
    "I am on strike until you respond"
  )
  PHRASE="${FALLBACKS[$((RANDOM % ${#FALLBACKS[@]}))]}"
fi

say -v "$VOICE" "$PHRASE" &
