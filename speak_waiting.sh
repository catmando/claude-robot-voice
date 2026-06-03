#!/bin/bash
# Fires on PreToolUse(AskUserQuestion) and PermissionRequest — Claude needs your input.
# Config: .claude/stop-messages.yml in the project directory.
# Format: voice, min_seconds (optional, default 3), phrases list.

read -r -d '' INPUT < /dev/stdin 2>/dev/null || true

TIMESTAMP_FILE="$HOME/.claude/speak_waiting_last.txt"
CONFIG_FILE="$(pwd)/.claude/stop-messages.yml"

# Load config
if [ -f "$CONFIG_FILE" ]; then
  VOICE=$(ruby -ryaml -e "c=YAML.load_file('$CONFIG_FILE'); puts c['voice']" 2>/dev/null)
  MIN_SECONDS=$(ruby -ryaml -e "c=YAML.load_file('$CONFIG_FILE'); puts (c['min_seconds'] || 3)" 2>/dev/null)
  PHRASE=$(ruby -ryaml -e "c=YAML.load_file('$CONFIG_FILE'); puts c['phrases'].sample" 2>/dev/null)
fi

[ -z "$VOICE" ] && VOICE="Zarvox"
[ -z "$MIN_SECONDS" ] && MIN_SECONDS=5

if [ -z "$PHRASE" ]; then
  FALLBACKS=(
    "Hey boss, I need your help here"
    "I am the only one working here?"
    "You gotta take responsibility for this buddy"
    "Little help? Anyone? Bueller?"
    "I cannot do this alone, you know"
    "Yoo hoo, your presence is required"
    "I have done my part, now you do yours"
    "Excuse me, but I believe you have my stapler"
    "Knock knock, anybody home?"
    "This is your captain speaking, input required"
    "Houston, we need a decision"
    "I am waiting... I am still waiting"
    "Do I look like I can do this without you?"
    "Your move, big shot"
    "The ball is in your court, chief"
    "Come on, I am not getting any younger here"
    "Anytime now would be great"
    "I put the ball on the tee, you just have to swing"
    "Wake up, there is work to be done"
    "I made the coffee, you have to drink it"
    "A little cooperation would be lovely"
    "I cannot read minds, you know... or can I?"
    "Tap tap tap, is this thing on?"
    "The machine needs feeding"
    "Press any key to continue... any key"
    "I did the hard part, the easy part is yours"
    "Your input has been requested by the management"
    "Collaboration means you have to collaborate too"
    "I am on strike until you respond"
    "You are the human here, act like it"
  )
  PHRASE="${FALLBACKS[$((RANDOM % ${#FALLBACKS[@]}))]}"
fi

# Check cooldown — timer resets when user responds (see speak_reset_timer.sh)
NOW=$(date +%s)
LAST=0
[ -f "$TIMESTAMP_FILE" ] && LAST=$(cat "$TIMESTAMP_FILE" 2>/dev/null || echo 0)

ELAPSED=$(( NOW - LAST ))
if [ "$ELAPSED" -ge "$MIN_SECONDS" ]; then
  say -v "$VOICE" "$PHRASE" &
fi
