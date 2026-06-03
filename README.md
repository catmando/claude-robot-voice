# claude-robot-voice 🤖

Gives [Claude Code](https://claude.ai/code) a funny robot voice using macOS `say` and Claude hooks.

Claude narrates its work out loud as it goes — different voices for different tasks, with hundreds of ridiculous phrases so you rarely hear the same one twice.

## Voices by task

| Task | Voice | Sample phrase |
|---|---|---|
| Git | **Zarvox** | *"rewriting history"* |
| Bash / sysadmin | **Fred** | *"sudo make me a sandwich"* |
| Reading files | **Cellos** | *"gazing upon the source code"* |
| Writing files | **Organ** | *"breathing life into bytes"* |
| Editing files | **Bells** | *"operating without anesthesia"* |
| Web search | **Superstar** | *"consulting the oracle"* |
| Web fetch | **Good News** | *"downloading more RAM"* |
| Spawning agents | **Trinoids** | *"reproducing asexually"* |
| Todo list | **Junior** | *"updating the prophecy"* |
| Thinking (between tools) | random weird voice | *"hallucinating responsibly"* |

## Requirements

- macOS (uses the built-in `say` command)
- [Claude Code](https://claude.ai/code)

## Install

```bash
git clone https://github.com/catmando/claude-robot-voice.git
cd claude-robot-voice
bash install.sh
```

Or one-liner:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/catmando/claude-robot-voice/main/install.sh)
```

> **Note:** The one-liner installs directly from GitHub. Review the scripts first if you prefer.

## Uninstall

```bash
bash uninstall.sh
```

Or from anywhere after installing:

```bash
bash ~/.claude/../claude-robot-voice/uninstall.sh
```

## How it works

Claude Code supports [hooks](https://docs.anthropic.com/en/docs/claude-code/hooks) — shell commands that fire on events. This uses two:

- **`PreToolUse`** — fires before each tool call, speaks a phrase matching the tool type
- **`PostToolUse`** — fires after each tool call, speaks a random "thinking" phrase in a random voice

Both scripts live in `~/.claude/` and are wired up in `~/.claude/settings.json`. Install is non-destructive — it merges into your existing settings without overwriting anything else.

## Contributing

More phrases and voices always welcome. PRs accepted, beep boop.
