#!/bin/bash

# Set the AWS region where your ECR repository is located
AWS_REGION=$1

# List all ECR repositories in the specified region
REPOSITORIES=$(aws ecr describe-repositories --region $AWS_REGION --query 'repositories[].repositoryName' --output text)

# Loop through each repository
for REPO_NAME in $REPOSITORIES
do
  # List all image IDs in the repository
  IMAGE_IDS=$(aws ecr list-images --region $AWS_REGION --repository-name $REPO_NAME --query 'imageIds[].{imageDigest:imageDigest}' --output text)

  # Loop through each image ID and delete it
  for IMAGE_ID in $IMAGE_IDS
  do
    echo "Deleting image in repository $REPO_NAME with image ID: $IMAGE_ID"
    aws ecr batch-delete-image --region $AWS_REGION --repository-name $REPO_NAME --image-ids imageDigest=$IMAGE_ID
  done

  echo "All images in repository $REPO_NAME have been deleted."
done

echo "All ECR images in region $AWS_REGION have been deleted."