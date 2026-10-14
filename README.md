# MQIT course environment for Windows

This installs the local VS Code, Python, Jupyter kernel, Git and Microsoft QDK environment used by PHY5001. The default setup contains the exam tools only; extra workshop tools are optional. It targets **64-bit Windows x64** and PowerShell **5.1 or 7**. No Azure account or quantum hardware is required.

## Install before classes or the exam

1. Use the installer revision supplied by teaching staff. Download/extract the **complete repository**, including `Setup.Common.ps1`, `requirements.txt`, `git.inf` and `test/`. Do not mix files from different releases. The former `MQIT-Portable` tag does not acquire fixes made on `main`; staff must publish and distribute a new tested release.
2. Extract into a writable local folder, preferably outside OneDrive/network folders. Keep it there: virtual environments and Jupyter kernel registrations contain absolute paths and cannot safely be moved by copying.
3. Open PowerShell in the extracted folder and run:

   ```powershell
   powershell -NoProfile -ExecutionPolicy Bypass -File .\install.ps1
   ```

   This execution-policy setting is limited to this process. If institutional policy blocks installation, ask IT. Installation does not require changing system Python or administrator privileges.
4. Wait for **Setup checks passed**. A failure stops setup and prints the failing step. Correct it and rerun the same command; successful steps and downloads are reused. Do not proceed merely because VS Code can open.
5. In the course VS Code, open `test/testQ.ipynb`, select **MQIT (Python 3.12)** (registered as `mqit_kernel`) and run every cell. Check the Q# result and click the widget to verify frontend communication. Allow the repository's code to run when workspace/notebook trust prompts appear.

The installer supplies embedded CPython **3.12.9**, a `mqit/mqit-env` virtual environment, the Python/Jupyter/QDK VS Code extensions, and the eight pinned direct dependencies in `requirements.txt`. `qsharp` is retained as a compatibility shim for older course notebooks; new code uses `from qdk import qsharp`. It does not install the legacy .NET IQ# kernel or a JupyterLab server. VS Code is the notebook frontend.

## Launch for subsequent sessions

From the installer folder:

```powershell
.\launch.ps1 -Folder "C:\path\to\your\assignment-repository"
```

The launcher opens the portable VS Code and sets PATH for its process to the course Python and Git. Select **MQIT (Python 3.12)** as the notebook kernel. If its display name differs, select `mqit\mqit-env\Scripts\python.exe` explicitly. Avoid opening a different installed VS Code by accident.

In the VS Code terminal, verify `git --version` and configure your own Git identity and GitHub authentication. The installer cannot validate access to a student's Classroom50 repository. Use a practice assignment to test an actual commit and push before the exam.

## Optional workshop tools

The exam and QDK tests need only the default installation. For classes that use interactive Matplotlib plots or pyQuirk:

```powershell
.\install.ps1 -IncludeWorkshopTools
```

These add `ipympl` and `pyQuirk` through `requirements-workshops.txt`; their dependencies can increase download size. Rerunning without the switch does not remove previously installed tools. Other teaching software should get a separate explicitly selected requirements file rather than becoming an exam prerequisite.

## Repeated installation and troubleshooting

- Existing Python, virtual environment, Git and VS Code are reused. The script reconciles pinned direct Python packages, checks dependencies, tests Q#, and installs missing extensions. Close course VS Code/notebooks before changing installed packages.
- Downloads and pip's cache live under `mqit/cache`. PowerShell download progress is disabled to avoid its overhead. A failed download's `.partial` file is removed. If an archive itself is corrupt, delete that specific cached archive and rerun. A broken existing Python/Git/VS Code is reported; it is not silently deleted.
- The Git installer is signature-checked, awaited, and checked for success. Downloads are over HTTPS. New installations use the latest Git release; subsequent runs reuse the installed Git/cache. Ask staff to manage updates between assessments.
- `mqit/requirements.installed.txt` records actual installed Python packages, and `mqit/installation.json` records Python, Git, VS Code and extension versions. Share these with staff for diagnosis. No packages are skipped after failed installations.
- Run diagnostics using the intended interpreter:

  ```powershell
  & .\mqit\mqit-env\Scripts\python.exe -m pip check
  & .\mqit\mqit-env\Scripts\python.exe .\test\smoke_test.py
  ```

- If a kernel points at a deleted/moved installation, rerun setup from the intended location to replace its registration. Do not copy a working virtual environment to a different path.
- `install.ps1 -NoLaunch` performs setup without opening VS Code. `-VSCodeVersion 1.100.3` illustrates how to request an exact archive version for a *fresh* installation; use a staff-tested version. It does not replace an existing VS Code installation. The default downloads stable VS Code once. Extensions remain independently versioned; staff must freeze the validated lab image before the exam.

## Staff validation and release

Run `test/Test-Setup.ps1` for helper tests. Test a clean installation and a second cached run on the actual lab Windows image in PowerShell 5.1 and 7, including a path containing spaces and a non-administrator account. Verify all notebook cells, live widget clicks, Git authentication and a real Classroom50 submission. Test interrupted downloads and blocked network access. Do not distribute before this Windows acceptance run.

Eight direct requirements are pinned, but transitive versions and fresh Git/VS Code/extensions may change. After validating the lab image, retain its `requirements.installed.txt`, downloaded artifacts and version manifest, or produce a Windows-specific locked wheelhouse. Cross-platform pip resolution is useful for checking wheels but does not fully simulate Windows dependency markers. Publish a new immutable installer release and update teaching links to it.

## Uninstall

Close the course VS Code and kernels first. From this installer folder run:

```powershell
.\uninstall.ps1
```

It asks for confirmation. `-Force` skips that prompt. It removes this folder's `mqit` installation and its kernel registration only if that registration belongs to this installation. Keep assignment repositories outside `mqit`; uninstalling removes everything in that directory, including its cache. It does not remove another installation's kernel or change machine-wide PATH.
