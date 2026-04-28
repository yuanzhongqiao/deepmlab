REM Execute module test for a module named %TEST%, download and install latest build if needed

@echo on
set INSTALL_DIR=%SCILAB_COMMON_PATH%\%SCI_VERSION_STRING%\install
set SCIHOME=%SCILAB_COMMON_PATH%\%SCI_VERSION_STRING%\scihome\%SCI_VERSION_STRING%-%TEST%-%CI_CONCURRENT_ID%
set LOG_PATH=%SCI_VERSION_STRING%\%ARCH%-windows

REM Create log folder
if not exist %LOG_PATH% mkdir %LOG_PATH%

@echo on
setlocal EnableExtensions

rem can happen in case of retrying a job
if exist -d "%SCIHOME%" rmdir "%SCIHOME%" 
mkdir "%SCIHOME%"

REM check if Scilex exists
if not exist "%INSTALL_DIR%\bin\Scilex.exe" (
  echo "%INSTALL_DIR%\bin\Scilex.exe does not exist."
  exit 1
)

@echo on
call "%INSTALL_DIR%\bin\Scilex.exe" -scihome "%SCIHOME%" -quit -e "test_run('%TEST%',[],[],'%LOG_PATH%\%TEST%.xml'); [__msg__, __err__] = lasterror(), exit(__err__)"
if errorlevel 1 (
  echo "Scilab exit with code %errorlevel%"
  exit 1
)

rem fail without xml report
copy "%LOG_PATH%\%TEST%.xml" "%SCILAB_COMMON_PATH%\%SCI_VERSION_STRING%\test\"
if errorlevel 1 exit 1
