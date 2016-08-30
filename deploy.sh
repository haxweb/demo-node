#!/bin/bash

# Exit on any error
set -e

docker build -t gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1 .

docker tag gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1 gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:latest

${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/gcloud docker push gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1

${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/kubectl patch rc ${APP_NAME} \
	-p '{"spec":{"template":{"spec":{"containers":[{"name":"'${APP_NAME}'","image":"gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:'"$CIRCLE_SHA1"'"}]}}}}'
