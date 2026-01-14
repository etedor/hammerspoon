# WindowManager.spoon

## Workflow

Follow the **Explore-Plan-Code-Commit** pattern:

1. **Explore**: Read files, understand existing code before proposing changes
2. **Plan**: Create implementation plans, consider edge cases
3. **Code**: Make focused changes with clear intent
4. **Commit**: Update documentation, rebuild zip, commit with attribution

**Living Documentation**: Use the `#` key during sessions to auto-update this file with learned patterns.

## Git Worktrees

When working in a worktree context (additional directory ending in pattern like `hammerspoon-feat-name`):

**CRITICAL**: Always `cd` into the worktree directory before running git commands. Bash commands execute in the original working directory by default.

```bash
# correct - commands run in worktree context
cd ../hammerspoon-feat-name && git status
cd ../hammerspoon-feat-name && git add -A && git commit

# incorrect - commands run in main directory
git status
```

When in doubt about which directory a command will execute in, explicitly specify the path.

## Commit Messages

All commits include Claude Code attribution:

```
<terse description>

<optional details>

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

## Repository Structure

This repository follows the SpoonInstall format for automatic installation via Hammerspoon's SpoonInstall plugin.

```
.
├── WindowManager.spoon/     # source code
├── Spoons/                  # packaged spoon for distribution
│   └── WindowManager.spoon.zip
├── docs/                    # metadata for SpoonInstall
│   └── docs.json
└── README.md
```

**Why both source and zip?**
- `WindowManager.spoon/` contains editable source code
- `Spoons/WindowManager.spoon.zip` is what SpoonInstall downloads and installs
- Users installing via SpoonInstall get the zip; manual installation uses the source directory

## Build Process

**CRITICAL:** After making changes to `WindowManager.spoon/`, you MUST rebuild the zip or changes won't propagate to users:

```bash
zip -r Spoons/WindowManager.spoon.zip WindowManager.spoon/
git add Spoons/WindowManager.spoon.zip
git commit -m "update spoon package"
git push
```

## Testing

Test changes locally before committing:

```bash
# reload hammerspoon to test changes
open -g hammerspoon://reload

# check for errors in hammerspoon console
open -a Hammerspoon
```

SpoonInstall will auto-update from GitHub on each Hammerspoon reload (when using `use_syncinstall = true`).

## SpoonInstall Requirements

SpoonInstall fetches from these URLs:
- Metadata: `https://github.com/<user>/<repo>/raw/master/docs/docs.json`
- Package: `https://github.com/<user>/<repo>/raw/master/Spoons/WindowManager.spoon.zip`

The `docs.json` must contain at minimum a name field and repository metadata.

## Style

- Comments: lowercase, terse
- Acronyms in comments: UPPERCASE (HDMI, DDC, USB, macOS, etc.)
- Product names: capitalize properly (Hammerspoon, Ghostty, macOS)
- Lua conventions: camelCase for variables/functions, TitleCase for Spoon names
- No emoji in code
