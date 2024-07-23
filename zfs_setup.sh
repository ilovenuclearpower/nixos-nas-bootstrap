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
    source "/etc/bootstrap"
    echo ${VDEV_MAX}
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
    nvme_count=${#NVME_DISKS[@]}
    added_disks=()
    echo $sata_count
    for value in "${SATA_DISKS[@]}"; do
        added_disks+=("$value")
        if [[ ${#added_disks[@]} -ge ${VDEV_MAX} ]]; then
            echo "Reached maximum size"
	    all_devices=$(IFS=" "; echo "${added_disks[@]:0:(($VDEV_MAX - 1))}")
	    IFS=' ' read -ra devices <<< "$all_devices"
	    unset IFS
            echo "Check device counts"	    
	    echo ${devices[@]}
            echo ${added_disks[-1]}
	    if ! zpool list galaxy > /dev/null 2>&1; then
		echo "Atempting to create first galaxy vdev"
                zpool create galaxy-$(hostname) raidz2 ${devices[@]}
	        zpool add galaxy-$(hostname) spare ${added_disks[-1]}
	    else
		echo "Attempting to add new vdev"
		zpool add galaxy-$(hostname) raidz2 ${devices[@]}
		zpool add galaxy-$(hostname) spare ${added_disks[-1]}
	    fi
            added_disks=()
        fi
    done
    echo ${#added_disks[@]}
    if [ "${#added_disks[@]}" -le 6 ]; then
        echo "Smaller pool than required for raidz2"
	echo ${added_disks[@]}
	len=${#added_disks[@]}
	last_index=$((len - 1))
        for ((i=0; i<=$last_index; i+=2)); do
            device1=${added_disks[i]}
	    device2=${added_disks[(i+1)]}
	    echo $i
	    echo ${#added_disks[@]}
	    if [ $i -lt $last_index ]; then
		echo "Two drives detected, mirror configuration"
                echo $device1 $device2
		zpool add -f galaxy-$(hostname) mirror $device1 $device2
            else
		echo "One drive detected, adding spare"
                echo $device1
		zpool add -f galaxy-$(hostname) spare $device1
            fi
	done
    else
        echo "bigger than required"
	spare_vdev=$(IFS=" "; echo "${added_disks[*]}")
	echo $spare_vdev
	zpool add galaxy-$(hostname) raidz2 $spare_vdev
    fi
    for value in "${NVME_DISKS[@]}"; do
        echo $value
	zpool add galaxy-$(hostname) cache $value
    done
}
create_zfs_pools
# Create the 'apps' dataset with a record size of 4K
sudo zfs create -o mountpoint=legacy -o recordsize=4096 galaxy-$(hostname)/apps

# Create the 'media' dataset with a record size of 512K
sudo zfs create -o mountpoint=legacy -o recordsize=524288 galaxy-$(hostname)/media

# Create the 'files' dataset with a record size of 32K
sudo zfs create -o mountpoint=legacy -o recordsize=524288  galaxy-$(hostname)/files
sudo zfs create -o mountpoint=legacy -o recordsize=524288 galaxy-$(hostname)/nix
sudo zfs create -o mountpoint=legacy -o recordsize=524288 galaxy-$(hostname)/frontier
sudo zfs create -o mountpoint=legacy -o recordsize=524288 galaxy-$(hostname)/wilds
