#!/bin/bash
set -e

# Set variables
DISTRO="ubuntu"
DIST_VERSION="jammy"
DOCKER_DOWNLOAD_URL="https://download.docker.com"
DOCKER_CHANNEL="stable"
PKG_DIR="./SubHost.Installer/deb-packages"
TAR_DIR="./SubHost.Installer"
PKGS="docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-ce-rootless-extras docker-buildx-plugin"

# Create output directory
mkdir -p $PKG_DIR

# Function to install required tools
install_required_tools() {
    echo "Installing required tools..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
}

# Function to add Docker's official GPG key
add_docker_gpg_key() {
    echo "Adding Docker's official GPG key..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg --yes
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] $DOCKER_DOWNLOAD_URL/linux/ubuntu $DIST_VERSION $DOCKER_CHANNEL" | sudo tee /etc/apt/sources.list.d/docker.list
}


# Function to download, rename, and move a single package
download_package() {
    local PKG=$1
    echo "Downloading $PKG..."
    local VERSION=$(apt-cache madison $PKG | head -1 | awk '{print $3}')
    apt download $PKG=$VERSION

    echo "Renaming and moving $PKG..."
    for FILE in ${PKG}_*.deb; do
        if [[ "$FILE" == *"%3a"* ]]; then
            local NEW_FILE=$(echo $FILE | sed 's/%3a/:/g')
            mv "$FILE" "$PKG_DIR/$NEW_FILE"
        else
            mv "$FILE" "$PKG_DIR"
        fi
    done
}

tar_installer() {
    echo "Creating tarball of installer..."
    tar -czf ./SubHost.Installer.tar.gz $TAR_DIR
}

# Main function to orchestrate the steps
main() {
    install_required_tools
    add_docker_gpg_key

    sudo apt-get update

    for PKG in $PKGS; do
        download_package $PKG
    done

    tar_installer
}

# Run the main function
main
