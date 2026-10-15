# Install `ctxseven`

## Quick Install (Windows PowerShell)

```powershell
.\install.ps1
```

This script:
- Configures `PYTHONIOENCODING=utf-8` at the user level (persistent across sessions)
- Sets it for the current session (works immediately)
- Installs ctxseven via `uv tool`
- Verifies the installation
- Checks for the `CONTEXT7_API_KEY` environment variable

---

## Manual Installation

```bash
uv tool install git+https://github.com/davidw-philips/ctxseven
export CONTEXT7_API_KEY="your-context7-api-key"
ctxseven --help
```

Alternatives:

```bash
uvx --from git+https://github.com/davidw-philips/ctxseven ctxseven --help
pipx install git+https://github.com/davidw-philips/ctxseven.git
pip install git+https://github.com/davidw-philips/ctxseven.git
```

Windows PowerShell:

```powershell
uv tool install git+https://github.com/davidw-philips/ctxseven
$env:CONTEXT7_API_KEY="your-context7-api-key"
ctxseven --help
```