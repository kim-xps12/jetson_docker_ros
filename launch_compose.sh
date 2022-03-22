#!/bin/sh

echo "Setting xauth..." 
XAUTH=/tmp/.docker.xauth 
touch $XAUTH 
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

echo "Build and Start container" 
docker-compose up -d
docker attach melodic_docker
