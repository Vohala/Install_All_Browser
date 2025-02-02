# --------------------------------------------------------------------
# Silent Install of Google Chrome and/or Mozilla Firefox
# with Automatic Elevation and BITS-based downloads
# --------------------------------------------------------------------

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Not running as admin; attempting to re-launch as administrator..."

    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo "PowerShell"
        # -NoProfile avoids loading the user's profile 
        # -ExecutionPolicy Bypass ensures the script runs unrestricted
        # -File runs this exact script file
        $psi.Arguments = '-NoProfile -ExecutionPolicy Bypass -File "' + $PSCommandPath + '"'
        $psi.Verb      = 'runas'

        [System.Diagnostics.Process]::Start($psi) | Out-Null
    } catch {
        Write-Host "Unable to elevate privileges. Error: $_" -ForegroundColor Red
    }
    
    exit
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$tempDir = Join-Path $env:TEMP "Installers"
try {
    if (!(Test-Path $tempDir)) {
        New-Item -ItemType Directory -Path $tempDir -Force -ErrorAction Stop | Out-Null
    }
} catch {
    Write-Host "Failed to create or access temp directory: $_" -ForegroundColor Red
    Write-Host "Press any key to exit..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

function Install-Chrome {
    $chromeUrl       = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"
    $chromeInstaller = Join-Path $tempDir "GoogleChrome.msi"
    
    try {
        Write-Host "`nDownloading Google Chrome (BITS) from:`n$chromeUrl"
        
        Start-BitsTransfer -Source $chromeUrl -Destination $chromeInstaller -DisplayName "Chrome Download"
        
        Write-Host "`nDownload completed. Installing Google Chrome silently..."
        Start-Process "msiexec.exe" -ArgumentList "/i `"$chromeInstaller`" /qn /norestart" -Wait

        Write-Host "Google Chrome installation completed."
        return $true
    } catch {
        Write-Host "Error installing Google Chrome: $_" -ForegroundColor Red
        return $false
    }
}

function Install-Firefox {
    $ffUrl       = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"
    $ffInstaller = Join-Path $tempDir "FirefoxInstaller.exe"
    
    try {
        Write-Host "`nDownloading Mozilla Firefox (BITS) from:`n$ffUrl"

        Start-BitsTransfer -Source $ffUrl -Destination $ffInstaller -DisplayName "Firefox Download"
        
        Write-Host "`nDownload completed. Installing Mozilla Firefox silently..."
        Start-Process -FilePath $ffInstaller -ArgumentList "-ms" -Wait

        Write-Host "Mozilla Firefox installation completed."
        return $true
    } catch {
        Write-Host "Error installing Mozilla Firefox: $_" -ForegroundColor Red
        return $false
    }
}

Write-Host "`nDeveloped by Vohala just Select which browser(s) to install:"
Write-Host "1. Google Chrome"
Write-Host "2. Mozilla Firefox"
Write-Host "3. Both Chrome and Firefox"

$choice = Read-Host "Enter your choice (1, 2, or 3)"

switch ($choice) {

    "1" { 
        if (-not (Install-Chrome)) {
            Write-Host "Chrome installation failed."
            Write-Host "Press any key to exit..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit 1
        }
    }

    "2" { 
        if (-not (Install-Firefox)) {
            Write-Host "Firefox installation failed."
            Write-Host "Press any key to exit..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit 1
        }
    }

    "3" {
        if (Install-Chrome) {
            if (-not (Install-Firefox)) {
                Write-Host "Firefox installation failed."
                Write-Host "Press any key to exit..."
                $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
                exit 1
            }
        } else {
            Write-Host "Chrome installation failed."
            Write-Host "Press any key to exit..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
            exit 1
        }
    }

    Default {
        Write-Host "Invalid option selected. Exiting."
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
}

Write-Host "`nInstallation process completed successfully."
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
