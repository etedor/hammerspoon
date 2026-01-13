# WindowManager.spoon

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
