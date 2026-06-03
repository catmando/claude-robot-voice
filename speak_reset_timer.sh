#!/bin/bash
# Fires on UserPromptSubmit — user has responded. Reset the speak cooldown timer.
cat /dev/stdin > /dev/null 2>&1 || true
date +%s > "$HOME/.claude/speak_waiting_last.txt"
