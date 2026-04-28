# Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
# Copyright (C) 2025 - Dassault Systèmes S.E. - Clément DAVID
#
# This powershell script file install the windows binary in a shared directory
# on the CI VM. It also re-install in case of a retry.
#

# Define installation directory
$INSTALL_DIR = "${env:SCILAB_COMMON_PATH}\${env:SCI_VERSION_STRING}\install"

# Create a temporary directory for the installer
New-Item -ItemType Directory -Path "${env:SCI_VERSION_STRING}" -Force -ErrorAction Stop

# Check if the uninstaller exists
$uninstaller = Get-Item "${INSTALL_DIR}\unins000.exe" -ErrorAction SilentlyContinue

# Uninstall previous version if it exists
if (Test-Path -Path "$INSTALL_DIR" -PathType Container) {
    if ($uninstaller) {
        Write-Output "Running uninstaller: $($uninstaller.FullName)"
        try {
            $uninstallLog = "${env:SCI_VERSION_STRING}\test_iss_uninstall_${env:CI_COMMIT_SHORT_SHA}.log"
            Start-Process -FilePath $uninstaller.FullName `
                -ArgumentList '/SILENT','/SUPPRESSMSGBOXES','/FORCECLOSEAPPLICATIONS',"/LOG=$uninstallLog" `
                -NoNewWindow -Wait -ErrorAction Stop
        }
        catch {
            Write-Output "Warning: Failed to run uninstaller $($uninstaller.FullName): $($_.Exception.Message)"
        }

        # Copy and archive the uninstall log
        $timestamp = (Get-Date -Format "o").Replace(":", ".")
        $sharedLog = "${env:SCILAB_COMMON_PATH}\${env:SCI_VERSION_STRING}\log\test_iss_uninstall_${env:CI_COMMIT_SHORT_SHA}_$timestamp.log"
        Copy-Item -Path $uninstallLog -Destination $sharedLog -Force

        # Remove the installation directory
        Remove-Item -Path "$INSTALL_DIR" -Recurse -Force -ErrorAction Stop
        Write-Output "Removed: $INSTALL_DIR"
    }
}

# Run the installer
$installerExe = Get-Item "${env:SCI_VERSION_STRING}.bin.${env:ARCH}.exe"
try {
    $installLog = "${env:SCI_VERSION_STRING}\test_iss_install_${env:CI_COMMIT_SHORT_SHA}.log"
    Start-Process -FilePath $installerExe.FullName `
        -ArgumentList "/TASKS=!desktopicon,!AssociateSCESCI,!AssociateTSTDEM,!AssociateSCICOS,!AssociateSOD",`
                      "/NOICONS","/SUPPRESSMSGBOXES","/SILENT","/SP-","/LOG=$installLog","/DIR=$INSTALL_DIR" `
        -NoNewWindow -Wait -ErrorAction Stop
}
catch {
    Write-Output "Warning: Failed to run installer $($installerExe.FullName): $($_.Exception.Message)"
}

# Copy and archive the install log
$timestamp = (Get-Date -Format "o").Replace(":", ".")
$sharedLog = "${env:SCILAB_COMMON_PATH}\${env:SCI_VERSION_STRING}\log\test_iss_install_${env:CI_COMMIT_SHORT_SHA}_$timestamp.log"
Copy-Item -Path $installLog -Destination $sharedLog -Force
