#!/bin/bash

docker build -t gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1 .

docker tag gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1 gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:latest

${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/gcloud docker push gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1

appreplication=`$CLOUDSDK_INSTALL_DIR/google-cloud-sdk/bin/kubectl get rc | grep "$APP_NAME"`

if [ "$appreplication" == "" ]; then
        echo "Application ${APP_NAME} not yet deployed. deploying..."
	${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/kubectl create -f deploy/replica.yml -f deploy/service.yml
else
        echo "Application replication controller found, rolling-update ${APP_NAME} with new image..."
	${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/kubectl rolling-update ${APP_NAME} \
		--image="gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1"
fi
