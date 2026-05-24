# Dependency Safety

## What's enforced and where

### npm — `~/.npmrc`

| Setting | Effect |
|---|---|
| `ignore-scripts=true` | Blocks all lifecycle scripts: `preinstall`, `postinstall`, `postuninstall`, etc. |
| `save-exact=true` | `npm install <pkg>` saves exact versions (`1.2.3`) instead of ranges (`^1.2.3`) |

These apply globally to all npm projects on this machine.

### pip — `~/.config/pip/pip.conf`

| Setting | Effect |
|---|---|
| `only-binary=:all:` | Only installs pre-built wheels. Refuses to build from source, which prevents `setup.py` from running. |

### Age-gating — `~/.zshrc` (shell wrappers)

`npm-safe` and `pip-safe` wrap their respective installers and block any package whose **latest version was published less than 5 days ago**. This reduces exposure to the window between a supply-chain compromise and its detection.

```zsh
npm-safe lodash            # checks age, then runs: npm install lodash
pip-safe requests numpy    # checks both, then runs: pip install requests numpy
```

The wrappers check age but do not replace the underlying tool — flags pass through unchanged:

```zsh
npm-safe --save-dev typescript
pip-safe --upgrade requests
```

---

## Escape hatches

### npm: package needs to run build scripts (e.g. native compilation)

```zsh
npm install --ignore-scripts=false <pkg>
```

Common cases: `node-gyp`, `esbuild`, `sharp`, `bcrypt`, `canvas`.

### pip: package has no wheel (source-only)

```zsh
pip install --no-binary=<pkg> <pkg>
```

### Age gate: you've vetted the package and want to install anyway

Use the raw commands directly — `npm install` or `pip install` — bypassing the wrappers.

---

## Pinning workflow

### npm

`save-exact=true` pins new installs automatically. For CI, always use `npm ci` (installs from `package-lock.json` exactly, fails if it's out of date).

### pip

Global config alone doesn't pin. Use one of:

- **pip-tools** (minimal):
  ```
  pip install pip-tools
  # write requirements.in with loose deps
  pip-compile --generate-hashes requirements.in   # produces pinned requirements.txt
  pip install --require-hashes -r requirements.txt
  ```

- **uv** (faster, native lockfile):
  ```
  uv lock    # generates uv.lock
  uv sync    # installs from lockfile
  ```

---

## Gaps and known limitations

| Gap | Notes |
|---|---|
| `ignore-scripts` can break packages | Native-compilation packages (`node-gyp` etc.) need scripts. Use the escape hatch above. |
| `only-binary` can break source-only packages | Less common with modern packages, but use `--no-binary` when needed. |
| Age gate is advisory, not enforced | The raw `npm install` / `pip install` commands are unaffected. The wrappers are only as strong as your habit of using them. |
| Age gate checks latest version only | If you pin to a specific older version (`pkg@1.0.0`), the wrapper still checks the *latest* version's age, not the pinned version's. |
| No transitive checks | Age and script checks only cover direct installs, not the full dependency tree. Tools like [Socket.dev](https://socket.dev) cover the tree. |
| pip `require-hashes` not globally enabled | Enabling it globally breaks plain `pip install <name>` usage. It's only practical in a pip-tools/uv workflow where all hashes are pre-computed. |

---

## Going further

- **[Socket.dev](https://socket.dev)** — wraps npm with deep supply-chain analysis (typosquatting, compromised maintainers, install scripts, transitive deps). `npm install -g @socketsecurity/cli`, then `socket npm install <pkg>`.
- **Renovate** — for automated dependency updates, set `"minimumReleaseAge": "5 days"` in `renovate.json` to enforce the age gate on PRs.
- **`npm audit` / `pip-audit`** — scan installed deps for known CVEs.
