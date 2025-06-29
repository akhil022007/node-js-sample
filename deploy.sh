#!/bin/bash


IMAGE_NAME="my-nodejs-app"
CONTAINER_NAME="my-nodejs-app-container"
CONTAINER_PORT="5000" 
HOST_PORT="80" 

echo "--- Starting Deployment Script ---"



echo "Checking for existing container: $CONTAINER_NAME"
if docker ps -a --format '{{.Names}}' | grep -q "$CONTAINER_NAME"; then
  echo "Existing container '$CONTAINER_NAME' found. Stopping and removing..."
  docker stop "$CONTAINER_NAME"
  docker rm "$CONTAINER_NAME"
  echo "Container '$CONTAINER_NAME' stopped and removed."
else
  echo "No existing container '$CONTAINER_NAME' found."
fi


echo "Building Docker image: $IMAGE_NAME from current directory."
docker build -t "$IMAGE_NAME" .

if [ $? -ne 0 ]; then
  echo "ERROR: Docker image build failed!"
  exit 1
fi
echo "Docker image '$IMAGE_NAME' built successfully."


echo "Building Docker image: $IMAGE_NAME from current directory."
docker build -t "$IMAGE_NAME" .

if [ $? -ne 0 ]; then
  echo "ERROR: Docker image build failed!"
  exit 1
fi
echo "Docker image '$IMAGE_NAME' built successfully."
