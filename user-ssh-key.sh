#!/bin/sh
sshKeyPath=$1
echo "Start of script"
if [ ! -d "${sshKeyPath%/*}" ]; then
    echo "Not found, making directory"
    mkdir -p "${sshKeyPath%/*}";
else
    echo "Found directory"
fi

if [ ! -f "${sshKeyPath}" ]; then
    echo "Attempting to generate SSH key"
    which ssh
    ssh-keygen -t ed25519 -f ${sshKeyPath} -C $(whoami)@galaxy-$(hostname) -N "";
else
    echo "Found SSH key"
fi