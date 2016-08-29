#!/bin/bash

# Exit on any error
set -e


sudo /opt/google-cloud-sdk/bin/gcloud docker push gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube
kubectl patch rc ${APP_NAME} -p '{"spec":{"template":{"spec":{"containers":[{"name":"'${APP_NAME}'","image":"gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:'"$CIRCLE_SHA1"'"}]}}}}'
