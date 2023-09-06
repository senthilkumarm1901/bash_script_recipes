#!/bin/bash

# List EBS volumes and extract volume IDs
volume_ids=$(aws ec2 describe-volumes --query "Volumes[].VolumeId" --output text)

# Iterate through the volume IDs and delete each one
for volume_id in $volume_ids; do
    echo "Detaching EBS volume $volume_id"
    
    # Detach the volume from any associated instance (if attached)
    aws ec2 detach-volume --volume-id $volume_id
    
    # Wait for the volume to be detached before deletion
    aws ec2 wait volume-available --volume-ids $volume_id
    
    echo "Deleting EBS volume $volume_id"
    aws ec2 delete-volume --volume-id $volume_id
done