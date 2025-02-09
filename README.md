# Install_All_Browser

A PowerShell script that automatically elevates privileges (if needed) and silently installs Google Chrome and/or Mozilla Firefox. It uses BITS to download each browser from their official sources and then runs the installer in quiet mode.
Features

    Automatic Administrator Check
    If the script isn't run as admin, it re-launches itself with elevated privileges.
    BITS Download
    Uses [Start-BitsTransfer] for reliable background downloads of the installers.
    Silent Installation
    Installs Google Chrome (.msi) and/or Mozilla Firefox (.exe) without prompts (/qn, -ms).
    Friendly User Choices
    Prompts you to install:
        Google Chrome
        Mozilla Firefox
        Both Chrome & Firefox

Usage

    Download or copy the script (e.g., Browser_Install.ps1) to your Windows system.
    Run PowerShell as Administrator, or simply double-click if your system allows PowerShell scripts to run:

powershell -NoProfile -ExecutionPolicy Bypass -File .\Browser_Install.ps1

If not already elevated, the script re-launches itself with admin privileges.
When prompted, choose:

    1 to install Google Chrome
    2 to install Mozilla Firefox
    3 to install Both

Let the script download and install the browsers silently.
If everything is successful, you'll see a completion message.

# Developed by [Vohala].
Enjoy quick and silent browser installations!
