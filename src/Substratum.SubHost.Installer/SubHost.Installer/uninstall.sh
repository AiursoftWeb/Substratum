#!/bin/bash
set -e

PKGS="\
docker-ce \
docker-ce-cli \
containerd.io \
docker-compose-plugin \
docker-ce-rootless-extras \
docker-buildx-plugin \
"

for PKG in $PKGS; do
    sudo dpkg -r $PKG
done
