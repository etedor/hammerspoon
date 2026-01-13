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

## Build Process

After making changes to `WindowManager.spoon/`, rebuild the distribution package:

```bash
zip -r Spoons/WindowManager.spoon.zip WindowManager.spoon/
git add Spoons/WindowManager.spoon.zip
git commit -m "update spoon package"
git push
```

## SpoonInstall Requirements

SpoonInstall fetches from these URLs:
- Metadata: `https://github.com/<user>/<repo>/raw/master/docs/docs.json`
- Package: `https://github.com/<user>/<repo>/raw/master/Spoons/WindowManager.spoon.zip`

The `docs.json` must contain at minimum a name field and repository metadata.
