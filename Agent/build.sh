#!/bin/bash
IMAGE_NAME=jenkins/agent
REGISTRY_HOST=localhost
REGISTRY_PORT=5000

# Build the Docker image using the Dockerfile
docker build -t $IMAGE_NAME .

# Tag the image with the registry hostname and port
docker tag $IMAGE_NAME $REGISTRY_HOST:$REGISTRY_PORT/$IMAGE_NAME

# Push the image to the registry
docker push $REGISTRY_HOST:$REGISTRY_PORT/$IMAGE_NAME