#!/bin/sh
function check_zfs_pools() {
    local pool_list=$(zpool list -H -o name | tr '\n' ' ')
    if [ -z "$pool_list" ]; then
        echo "No ZFS pools found"
        return 0
    else
        echo "ZFS Pools exist"
        return 1
    fi
}
function acquire_unpartitioned_disks {
# Get a list of disk devices
interface=$1
local -n unpartitioned_drives=$2
echo $interface
disks=$(lsblk -o NAME,TYPE,TRAN | awk '$2 == "disk" {print}' | awk -v interface="$interface" '$3==interface {print $1}')

# Iterate over each disk device
for disk in $disks; do
    # Attempt to open the partition table of the disk device with partx
    sudo partx -v /dev/$disk > /dev/null 2>&1
    
    # Check the exit status of partx
    if [ $? -ne 0 ]; then
        unpartitioned_drives+="/dev/$disk:"
        # If partx failed (exit status != 0), print the device name
        echo "No partition table found on device: $disk"
    fi
done

}

function create_zfs_pools() {
    nvme_disks=""
    sata_disks=""
    check_zfs_pools
    exit_status=$?
    if [ $exit_status -eq 0 ]; then
        echo "No pools found, creating pools"
    else
        echo "Pools found! Aborting"
        return 1
    fi
    acquire_unpartitioned_disks nvme nvme_disks
    acquire_unpartitioned_disks sata sata_disks
    echo ${sata_disks}
    echo ${nvme_disks}
    IFS=':' read -ra SATA_DISKS <<< "$sata_disks"
    IFS=':' read -ra NVME_DISKS <<< "$nvme_disks"
    sata_count=${#SATA_DISKS[@]}
    echo ${SATA_DISKS[@]}
    nvme_count=${#NVME_DISKS[@]}
    echo $sata_count
}
create_zfs_pools
