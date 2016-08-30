#!/bin/bash

docker build -t gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1 .

docker tag gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1 gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:latest

${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/gcloud docker push gcr.io/${PROJECT_NAME}/${DOCKER_IMAGE}:$CIRCLE_SHA1

appreplication=`$CLOUDSDK_INSTALL_DIR/google-cloud-sdk/bin/kubectl get deployments | grep "$APP_NAME"`


echo "Update image tag with circle sha1 version..."
sed -i -e "s/__IMAGE__/gcr.io\/$PROJECT_NAME\/$DOCKER_IMAGE:$CIRCLE_SHA1/" deploy/replica.yml
cat deploy/replica.yml
echo "Done."

if [ "$appreplication" == "" ]; then
        echo "Application ${APP_NAME} not yet deployed. deploying..."
	${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/kubectl create -f deploy/replica.yml -f deploy/service.yml
else
        echo "Application replication controller found, rolling-update via apply command on ${APP_NAME} for new image..."
	${CLOUDSDK_INSTALL_DIR}/google-cloud-sdk/bin/kubectl apply -f deploy/replica.yml
fi
