#!/bin/bash

# Exit on any error
set -e




/home/ubuntu/demo-node/google-cloud-sdk/bin/kubectl patch rc ${APP_NAME} \ 
	-p '{"spec":{"template":{"spec":{"containers":[{"name":"'${APP_NAME}'","image":"gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:'"$CIRCLE_SHA1"'"}]}}}}'

