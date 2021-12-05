#!/usr/bin/env bash
. ./.deployment-env

echo "$ echo \"$REGISTRY_PASSWORD\"| docker login -u \"$REGISTRY_USER\" --password-stdin \"$REGISTRY_URL\""
echo "$REGISTRY_PASSWORD"| docker login -u "$REGISTRY_USER" --password-stdin "$REGISTRY_URL"
docker-compose pull
echo $ docker-compose up -d --force-recreate --remove-orphans &
docker-compose up -d --force-recreate --remove-orphans &