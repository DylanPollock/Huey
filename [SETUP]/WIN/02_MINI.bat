@echo off
setlocal enabledelayedexpansion

:: Change to the script's own directory
cd /d "%~dp0"

:: Clear screen and set color
cls
color 0A
echo [****|     02_MINI.bat - Minimal Development Environment Setup   |****]
echo.

:: Function to ensure the script is running with administrative privileges
:ensureAdmin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run this script as an administrator.
    pause
    exit /b %errorlevel%
)
goto :eof

:: Function to check the last command and exit if it failed
:checkError
if %errorlevel% neq 0 (
    echo Error: %1 failed with error code %errorlevel%.
    pause
    exit /b %errorlevel%
)
goto :eof

:: Function to perform initial system checks
:systemCheck
echo Performing system checks...
REM Check for Windows version
ver | find "10" >nul
call :checkError "Windows 10 Check"
REM Check for available disk space
for /f "tokens=3" %%a in ('dir /-C %SystemDrive% ^| findstr /R "bytes free$"') do set FreeSpace=%%a
echo Free space on %SystemDrive%: %FreeSpace%
REM Check for required software (e.g., PowerShell, Git)
powershell -command "Get-Command git -ErrorAction SilentlyContinue" >nul
call :checkError "Git Availability Check"
REM Add any other necessary checks here
goto :eof

:: Function to install Chocolatey if not already installed
:installChocolatey
if exist "%ProgramData%\chocolatey\bin\choco.exe" (
    echo Chocolatey is already installed.
) else (
    echo Installing Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    call :checkError "Chocolatey Installation"
)
goto :eof

:: Function to update system
:updateSystem
echo Updating system...
powershell -Command "Start-Process 'powershell' -ArgumentList 'sfc /scannow' -Verb RunAs"
call :checkError "sfc /scannow"
powershell -Command "Start-Process 'powershell' -ArgumentList 'DISM /Online /Cleanup-Image /RestoreHealth' -Verb RunAs"
call :checkError "DISM /Online /Cleanup-Image /RestoreHealth"
goto :eof

:: Function to install common tools
:installCommonTools
echo Installing common tools...
choco install -y git
call :checkError "Git Installation"
choco install -y nodejs
call :checkError "NodeJS Installation"
choco install -y vscode
call :checkError "VSCode Installation"
goto :eof

:: Function to clone repository
:cloneRepository
echo Cloning repository...
REM Change the repository URL to your desired repository
git clone https://github.com/example/repository.git
call :checkError "Repository Cloning"
goto :eof

:: Function to set up Python environment
:setupPythonEnv
echo Setting up Python virtual environment...
cd repository
call :checkError "Changing Directory to repository"
python -m venv venv
call :checkError "Python Virtual Environment Setup"
venv\Scripts\activate
call :checkError "Activating Virtual Environment"
pip install --upgrade pip
call :checkError "Upgrading pip"
pip install -r requirements.txt
call :checkError "Installing Python Dependencies"
goto :eof

:: Function to configure Git (Optional)
:configureGit
echo Configuring Git...
git config --global user.name "Your Name"
call :checkError "Git User Name Configuration"
git config --global user.email "your.email@example.com"
call :checkError "Git User Email Configuration"
goto :eof

:: Function to create common directories (Optional)
:createDirectories
echo Creating common directories...
mkdir %USERPROFILE%\Projects
call :checkError "Creating Projects Directory"
mkdir %USERPROFILE%\Tools
call :checkError "Creating Tools Directory"
goto :eof

:: Function to update environment variables (Optional)
:updateEnvVariables
echo Updating environment variables...
setx PATH "%PATH%;%USERPROFILE%\Tools"
call :checkError "Updating PATH Environment Variable"
goto :eof

:: Function to perform additional optional setup tasks (Optional)
:additionalSetup
echo Performing additional setup tasks...
REM Uncomment the tasks you need
REM echo Installing Python packages...
REM pip install some-package
REM call :checkError "Python Package Installation"
REM echo Configuring additional settings...
REM Add additional configuration commands here
goto :eof

:: Ensure the script runs with administrative privileges
call :ensureAdmin

:: Perform initial system checks
call :systemCheck

:: Install Chocolatey if not already installed
call :installChocolatey

:: Update system files and health
call :updateSystem

:: Install common tools
call :installCommonTools

:: Clone the repository
call :cloneRepository

:: Set up Python environment
call :setupPythonEnv

:: Configure Git
call :configureGit

:: Create common directories
call :createDirectories

:: Update environment variables
call :updateEnvVariables

:: Perform additional optional setup tasks
call :additionalSetup

echo [****| Minimal setup complete! |****]
pause
exit /b 0