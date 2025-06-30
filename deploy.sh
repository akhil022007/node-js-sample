
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

echo "Running new container: $CONTAINER_NAME, mapping host port $HOST_PORT to container port $CONTAINER_PORT"
docker run -d -p "$HOST_PORT":"$CONTAINER_PORT" --name "$CONTAINER_NAME" "$IMAGE_NAME"

echo "Waiting a few seconds for container to start..."
sleep 5

echo "Checking Docker container status:"
docker ps -a -f "name=$CONTAINER_NAME"

if docker ps -f "name=$CONTAINER_NAME" --format '{{.Status}}' | grep -q "Up"; then
  echo "SUCCESS: Container '$CONTAINER_NAME' is running and healthy."
else
  echo "ERROR: Container '$CONTAINER_NAME' is NOT running or exited!"
  echo "--- Container Logs for $CONTAINER_NAME ---"
  docker logs "$CONTAINER_NAME"
  echo "--- End Container Logs ---"
  exit 1
fi

echo "Container '$CONTAINER_NAME' started successfully. Access at http://localhost:$HOST_PORT"
echo "--- Deployment Script Finished ---"
