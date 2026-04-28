param (
    [string]$BasePath = $env:SCILAB_COMMON_PATH,
    [int]$KillHours = 4,
    [int]$UninstallHours = 48,
    [int]$DeleteHours = 72
)

Write-Output "=== Windows Cleanup Script ==="
Write-Output "Base path : $BasePath"
Write-Output "Timestamp : $(Get-Date)"
Write-Output ""

# --- Step 1: Kill old Scilab processes ---
Write-Output "[1/5] Killing Scilab processes older than $KillHours hours"
$oldProcs = Get-Process *scilex* -ErrorAction SilentlyContinue | Where-Object { $_.StartTime -lt (Get-Date).AddHours(-$KillHours) }
if ($oldProcs) {
    foreach ($p in $oldProcs) {
        Write-Output "Stopping process $($p.ProcessName) (PID $($p.Id)) started at $($p.StartTime)"
        try {
            Stop-Process -Id $p.Id -Force -ErrorAction Stop
        } catch {
            Write-Output "Warning: Could not stop process $($p.Id): $($_.Exception.Message)"
        }
    }
} else {
    Write-Output "No old Scilab processes found."
}
Write-Output ""

# --- Step 2: Uninstall old Scilab builds ---
Write-Output "[2/5] Uninstalling Scilab builds older than $UninstallHours hours"
$uninstallers = Get-ChildItem -Path "$BasePath\*\install\unins000.exe" -ErrorAction SilentlyContinue
$toUninstall = $uninstallers | Where-Object { $_.LastWriteTime -lt (Get-Date).AddHours(-$UninstallHours) }

foreach ($exe in $toUninstall) {
    Write-Output "Running uninstaller: $($exe.FullName)"
    try {
        Start-Process $exe.FullName -ArgumentList '/VERYSILENT','/SUPPRESSMSGBOXES','/FORCECLOSEAPPLICATIONS' -NoNewWindow -Wait -ErrorAction Stop
    } catch {
        Write-Output "Warning: Failed to run uninstaller $($exe.FullName): $($_.Exception.Message)"
    }
}
if (-not $toUninstall) {
    Write-Output "No Scilab uninstallers found."
}
Write-Output ""

# --- Step 3: Remove old common path folders ---
Write-Output "[3/5] Removing folders older than $DeleteHours hours"

function Remove-ItemSafe {
    param([string]$Path)
    try {
        if (Test-Path $Path) {
            attrib -r -s -h "$Path" /s /d 2>$null
            Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
            Write-Output "Removed: $Path"
        }
    } catch {
        Write-Output "Warning: Unable to remove $Path - $($_.Exception.Message)"
    }
}

$folders = Get-ChildItem -Path "$BasePath" -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddHours(-$DeleteHours) } |
    Sort-Object LastWriteTime

if ($folders) {
    foreach ($f in $folders) {
        Write-Output "Deleting: $($f.FullName) (Last modified: $($f.LastWriteTime))"
        Remove-ItemSafe -Path $f.FullName
    }
} else {
    Write-Output "No old folders found."
}
Write-Output ""

# --- Step 4: Clean temporary folders ---
Write-Output "[4/5] Cleaning TEMP folders (SCI_TMP*) older than $DeleteHours hours"
$tempDirs = Get-ChildItem -Path "$env:TEMP" -Directory -Filter "SCI_TMP*" -ErrorAction SilentlyContinue |
    Where-Object { $_.LastWriteTime -lt (Get-Date).AddHours(-$DeleteHours) }

foreach ($d in $tempDirs) {
    Write-Output "Deleting TEMP: $($d.FullName)"
    Remove-ItemSafe -Path $d.FullName
}

if (-not $tempDirs) {
    Write-Output "No old TEMP folders found."
}

# --- Step 5: Uninstall the current Scilab build (in case of a retry) ---
# This stage will fail if a pipeline (in test stage) is already running for the same commit,
# hence will not try to generate an identical package which will potentially not be tested
# because uninstall will fail in test stage (just after build stage).
Write-Output "[5/5] Uninstalling current Scilab build $env:SCI_VERSION_STRING"
$Path = "$BasePath\$env:SCI_VERSION_STRING"
$exe = Get-Item "$Path\install\unins000.exe" -ErrorAction SilentlyContinue

if (Test-Path -Path "$Path" -PathType Container) {
    if ($exe) {
        Write-Output "Running uninstaller: $($exe.FullName)"
        try {
            Start-Process $exe.FullName -ArgumentList '/VERYSILENT','/SUPPRESSMSGBOXES','/FORCECLOSEAPPLICATIONS' -NoNewWindow -Wait -ErrorAction Stop
        } catch {
            Write-Output "Warning: Failed to run uninstaller $($exe.FullName): $($_.Exception.Message)"
        }
    }
    # commented out as the log dir might be needed on other builds
    # Remove-Item -Path $Path -Recurse -Force -ErrorAction Stop
    Write-Output "Not Removed: $Path"
}
Write-Output ""

Write-Output ""
Write-Output "Cleanup completed successfully at $(Get-Date)"
exit 0
