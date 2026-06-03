# claude-robot-voice 🤖

Gives Claude Code a funny robot voice that speaks when it needs your input — on tool approval prompts and explicit questions.

## How it works

- Hooks into `AskUserQuestion` and `PermissionRequest` Claude Code events
- Reads voice and phrases from `.claude/stop-messages.yml` in your project directory
- Falls back to a built-in set of phrases with the Zarvox voice if no config is found
- One voice per project — different projects can have different voices

## Install

```bash
git clone https://github.com/catmando/claude-robot-voice
cd claude-robot-voice
./install.sh
```

## Configure a project voice

Copy the example config into your project's `.claude/` directory:

```bash
mkdir -p your-project/.claude
cp stop-messages.yml.example your-project/.claude/stop-messages.yml
```

Then edit it:

```yaml
voice: Fred
phrases:
  - Hey boss, I need your help here
  - I am the only one working here?
  - Your move, big shot
```

Run `say -v '?'` in Terminal to see all available macOS voices.

Add `.claude/stop-messages.yml` to your `.gitignore` so each developer can set their own voice.

## Uninstall

```bash
./uninstall.sh
```

## Requirements

- macOS (uses the built-in `say` command)
- Ruby (standard on macOS)
- [Claude Code](https://claude.ai/code)
