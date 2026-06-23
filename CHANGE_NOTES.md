# Change Notes

## Installer robustness

- Added fallback handling for Python package installation in `install.ps1`.
- The installer still tries the fast path first with `pip install -r requirements.txt`.
- If that full requirements install fails, the installer retries each requirement individually.
- Requirements that cannot be installed are skipped instead of stopping the full installation.
- The installer writes the successful package list to `mqit\requirements.effective.txt`.
- The installer writes skipped packages to `mqit\requirements.skipped.txt`.

## Git installer setup

- Fixed the Git installation path variable name used by `install.ps1`.
- Stopped appending the generated Git install directory to the tracked `git.inf` file on every run.
- The installer now creates a temporary `mqit\git-install.inf` file for the generated Git install path.

## Uninstall support

- Added `uninstall.ps1`.
- The uninstall script removes the generated `mqit` environment folder.
- It also removes the generated `GitInstall.exe` file if present.
- It removes the `mqit_kernel` Jupyter kernel spec from the user profile.
- It attempts to remove MQIT-related entries from Process, User, and Machine PATH values.
- The default uninstall mode prompts before removing files.
- A non-interactive uninstall is available with:

```powershell
.\uninstall.ps1 -Force
```

## Documentation

- Updated `README.md` with uninstall instructions.
