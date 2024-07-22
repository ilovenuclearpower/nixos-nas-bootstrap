#!/bin/bash

# List of devices to wipe
devices=("sdb" "sdc" "sdd" "sde" "sdf" "sdg" "sdh" "sdi" "sdj" "sdk" "sdl" "sdm" "nvme0n1")

# Loop through each device
for device in "${devices[@]}"; do
    echo "Wiping filesystem signatures from /dev/${device}..."
    sudo wipefs -a "/dev/${device}"
    echo "Finished wiping /dev/${device}."
done

echo "All devices wiped successfully."

