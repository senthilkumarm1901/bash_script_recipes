#!/bin/bash

# Get a list of all S3 bucket names
bucket_names=$(aws s3api list-buckets --query 'Buckets[].Name' --output text)

# Loop through each bucket name and check if it starts with "be-dev"
for bucket_name in $bucket_names; do
  if [[ $bucket_name == be-dev* ]]; then
    echo "Deleting S3 bucket: $bucket_name"
    # Delete the bucket (force delete by emptying it first)
    aws s3 rb "s3://$bucket_name" --force
  fi
done

