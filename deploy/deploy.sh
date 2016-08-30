#!/bin/bash

# Exit on any error

#docker build -t gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1 .

#docker tag gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1 gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:latest

#${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/gcloud docker push gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1
CLOUDSDK_INSTALL_DIR=/home
APP_NAME=demo-node

appreplication=$(`$CLOUDSDK_INSTALL_DIR/google-cloud-sdk/bin/kubectl get rc | grep $APP_NAME`)

if [ "$appreplication" == "" ]; then
	echo "BLBAL"
        echo "Application ${APP_NAME} not yet deployed. deploying..."
	${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/kubectl create -f replica.yml -f service.yml
else
        echo "Application replication controller found, patching ${APP_NAME} with new image..."
	${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/kubectl patch rc ${APP_NAME} \
		-p '{"spec":{"template":{"spec":{"containers":[{"name":"'${APP_NAME}'","image":"gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:'"$CIRCLE_SHA1"'"}]}}}}'
fi

