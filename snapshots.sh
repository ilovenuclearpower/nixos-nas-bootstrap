#!/bin/sh
  # Get the list of datasets as command line arguments
target_host="$1"  # Get the target host from the first argument
identity_file="$2"
snapshot_prefix="$3"
shift 3  # Get the ssh identity file from the second argument
datasets=("$@")

# Loop through each dataset and send snapshots to the target host
for dataset in "${datasets[@]}"; do
    # Generate the snapshot name based on the current date and time

    # Send the snapshot to the target host using zfs send and ssh
    zfs send "${dataset}@$(zfs list -t snapshot -o name -s creation -H grep ${dataset}@${snapshot_prefix})" | ssh -i "${identity_file}" "${target_host}" zfs receive -F "${dataset}"
done