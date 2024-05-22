#!/bin/bash

# Change to the script's own directory
cd "$(dirname "$0")"

# Clear screen and set color (only works in some terminals)
clear
echo -e "\033[0;32m[****|     01_FULL.sh - Full Development Environment Setup   |****]\033[0m"
echo

# Function to ensure the script is running with administrative privileges
ensureAdmin() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as an administrator."
        exit 1
    fi
}

# Function to check the last command and exit if it failed
checkError() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed with error code $?."
        logError "$1"
        exit 1
    fi
}

# Function to log errors
logError() {
    echo "$(date) - Error: $1 failed with error code $?" >> error_log.txt
}

# Function to perform initial system checks
systemCheck() {
    echo "Performing system checks..."
    # Check for Debian version
    lsb_release -d | grep "Debian GNU/Linux 13" > /dev/null
    checkError "Debian 13 Check"
    # Check for available disk space
    FreeSpace=$(df / | tail -1 | awk '{print $4}')
    echo "Free space on /: $FreeSpace KB"
    # Check for internet connectivity
    ping -c 1 google.com > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Error: No internet connection detected."
        logError "Internet Connectivity Check"
        exit 1
    fi
    # Check for required software
    which git > /dev/null 2>&1
    checkError "Git Availability Check"
}

# Function to install Chocolatey if not already installed
installChocolatey() {
    if command -v choco > /dev/null 2>&1; then
        echo "Chocolatey is already installed."
    else
        echo "Installing Chocolatey..."
        wget https://chocolatey.org/install.sh -O install_choco.sh
        bash install_choco.sh
        checkError "Chocolatey Installation"
    fi
}

# Function to install common tools
installCommonTools() {
    echo "Installing common tools..."
    choco install -y git
    checkError "Git Installation"
    choco install -y nodejs
    checkError "NodeJS Installation"
    choco install -y vscode
    checkError "VSCode Installation"
}

# Function to install additional tools
installAdditionalTools() {
    echo "Installing additional tools..."
    choco install -y python
    checkError "Python Installation"
    choco install -y docker-desktop
    checkError "Docker Installation"
}

# Function to clone the repository
cloneRepository() {
    echo "Cloning repository..."
    if [ ! -d "$HOME/Source" ]; then
        mkdir -p "$HOME/Source"
    fi
    cd "$HOME/Source"
    git clone https://github.com/your/repo.git
    checkError "Git Clone"
}

# Function to set up Python environment
setupPythonEnv() {
    echo "Setting up Python environment..."
    cd "$HOME/Source/repo"
    python3 -m venv venv
    checkError "Python Virtual Environment Setup"
    source venv/bin/activate
    checkError "Activate Python Virtual Environment"
    pip install -r requirements.txt
    checkError "Install Python Requirements"
}

# Function to configure Git
configureGit() {
    echo "Configuring Git..."
    git config --global user.name "Your Name"
    checkError "Git Config Username"
    git config --global user.email "your.email@example.com"
    checkError "Git Config Email"
}

# Function to create common directories
createDirectories() {
    echo "Creating common directories..."
    mkdir -p "$HOME/Projects"
    checkError "Creating Projects Directory"
    mkdir -p "$HOME/Tools"
    checkError "Creating Tools Directory"
}

# Function to update environment variables (Optional)
updateEnvVariables() {
    echo "Updating environment variables..."
    export PATH="$PATH:$HOME/Tools"
    checkError "Updating PATH Environment Variable"
}

# Function to install optional tools
installOptionalTools() {
    echo "Installing optional tools..."
    # Uncomment the tools you need
    choco install -y postman
    checkError "Postman Installation"
    choco install -y slack
    checkError "Slack Installation"
    choco install -y zoom
    checkError "Zoom Installation"
    choco install -y 7zip
    checkError "7zip Installation"
    choco install -y wget
    checkError "Wget Installation"
    choco install -y curl
    checkError "Curl Installation"
    choco install -y terraform
    checkError "Terraform Installation"
    choco install -y kubectl
    checkError "kubectl Installation"
    choco install -y minikube
    checkError "Minikube Installation"
    choco install -y awscli
    checkError "AWS CLI Installation"
    choco install -y azure-cli
    checkError "Azure CLI Installation"
}

# Main Execution Flow
echo "Ensuring script runs with administrative privileges..."
ensureAdmin

echo "Performing initial system checks..."
systemCheck

echo "Installing Chocolatey if not already installed..."
installChocolatey

echo "Installing common tools..."
installCommonTools

echo "Installing additional tools..."
installAdditionalTools

echo "Cloning the repository..."
cloneRepository

echo "Setting up Python environment..."
setupPythonEnv

echo "Configuring Git..."
configureGit

echo "Creating common directories..."
createDirectories

echo "Updating environment variables..."
updateEnvVariables

echo "Installing optional tools..."
installOptionalTools

echo -e "\033[0;32m[****| Full setup complete! |****]\033[0m"