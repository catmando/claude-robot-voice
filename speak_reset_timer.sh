#!/bin/bash
# Fires on UserPromptSubmit — user has responded. Reset the speak cooldown timer.
date +%s > "$HOME/.claude/speak_waiting_last.txt"
