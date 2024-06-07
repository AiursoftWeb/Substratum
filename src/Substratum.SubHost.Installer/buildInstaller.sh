#!/bin/bash
set -e
#==========================
# Basic Information
#==========================
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export DEBIAN_FRONTEND=noninteractive
export DISTRO="ubuntu"
export DIST_VERSION="jammy"
export DOCKER_DOWNLOAD_URL="https://download.docker.com"
export DOCKER_CHANNEL="stable"
export PKG_DIR="./SubHost.Installer/deb-packages"
export TAR_DIR="./SubHost.Installer"
export PKGS="docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-ce-rootless-extras docker-buildx-plugin ca-certificates curl"
export BUILD_OUTPUT="/tmp/SubHost.Installer.tar.gz"

#==========================
# Color
#==========================
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
Blue="\033[36m"
Font="\033[0m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
OK="${Green}[  OK  ]${Font}"
ERROR="${Red}[FAILED]${Font}"

#==========================
# Print Colorful Text
#==========================
function print_ok() {
  echo -e "${OK} ${Blue} $1 ${Font}"
}

function print_error() {
  echo -e "${ERROR} ${Red} $1 ${Font}"
}

#==========================
# Judge function
#==========================
judge() {
  if [[ 0 -eq $? ]]; then
    print_ok "$1 succeeded"
    sleep 1
  else
    print_error "$1 failed"
    exit 1
  fi
}

# Function to install required tools
install_required_tools() {
    print_ok "Updating package list..."
    sudo apt-get update
    judge "Updating package list"

    print_ok "Installing apt-transport-https, ca-certificates, curl, gnupg, and lsb-release..."
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    judge "Install apt-transport-https, ca-certificates, curl, gnupg, and lsb-release"
}

# Function to add Docker's official GPG key
add_docker_gpg_key() {
    print_ok "Adding Docker's official GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] $DOCKER_DOWNLOAD_URL/linux/ubuntu $DIST_VERSION $DOCKER_CHANNEL" | sudo tee /etc/apt/sources.list.d/docker.list
    judge "Adding Docker's official GPG key"
}


# Function to download, rename, and move a single package
download_package() {
    local pkg=$1
    local pkg_dir=$2
    
    print_ok "Downloading $pkg..."
    local VERSION=$(apt-cache madison $pkg | head -1 | awk '{print $3}')
    apt download $pkg=$VERSION
    judge "Downloading $pkg"

    print_ok "Renaming and moving $pkg..."

    mkdir -p $pkg_dir
    for FILE in ${pkg}_*.deb; do
        if [[ "$FILE" == *"%3a"* ]]; then
            local NEW_FILE=$(echo $FILE | sed 's/%3a/:/g')
            mv "$FILE" "$pkg_dir/$NEW_FILE"
        else
            mv "$FILE" "$pkg_dir"
        fi
    done
}

tar_installer() {
    local pkg=$1
    local folder=$2
    print_ok "Creating tarball of installer..."
    tar -czf $pkg $folder
    judge "Creating tarball of installer"

    print_ok "Installer tarball created at $pkg"
}

# Main function to orchestrate the steps
main() {
    install_required_tools
    add_docker_gpg_key

    print_ok "Updating package list..."
    sudo apt-get update
    judge "Updating package list"

    for PKG in $PKGS; do
        download_package $PKG $PKG_DIR
    done

    tar_installer $BUILD_OUTPUT $TAR_DIR
}

# Run the main function
main
