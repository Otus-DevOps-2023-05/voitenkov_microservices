#!/bin/bash
set +e
until sudo docker info; do sleep 1; done
docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
docker pull $CI_REGISTRY_IMAGE/reddit-app:latest
docker stop reddit-app || true
docker rm reddit-app || true
set -e
docker run -d --name reddit-app \
    --restart always \
    --pull always \
    --hostname reddit-app \
    $CI_REGISTRY_IMAGE/reddit-app:latest
