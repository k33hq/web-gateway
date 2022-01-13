#!/usr/local/bin/bash

#
#  Script to deploy arcane-web-proxy to GCP cloud run.
#

if [ -z "${BASH_VERSINFO}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ ${BASH_VERSINFO[0]} -lt 4 ]; then
  echo "This script requires Bash version >= 4"
  exit 1
fi

if [ -f .env ]; then
  set -o allexport
  source .env
  set +o allexport
fi

IMAGE=eu.gcr.io/"$GCP_PROJECT_ID"/nginx:1.21.5-alpine

# RESEARCH_UI_URL=$(gcloud run services describe research-ui --format=json | jq -r '.status.address.url')
# RESEARCH_UI_ADDRESS=${RESEARCH_UI_URL#"https://"}

echo Pushing docker image

docker build -t "$IMAGE" config
docker push "$IMAGE"

echo Deploying to GCP cloud run

gcloud run deploy arcane-web-proxy \
  --region europe-west1 \
  --image "$IMAGE" \
  --cpu=1 \
  --memory=512Mi \
  --min-instances=1 \
  --max-instances=1 \
  --concurrency=1000 \
  --set-env-vars=BACKEND_ADDRESS="$BACKEND_ADDRESS",RESEARCH_UI_ADDRESS="$RESEARCH_UI_ADDRESS",SERVER_DOMAIN_NAME="$SERVER_DOMAIN_NAME",NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/ \
  --service-account arcane-web-proxy@"$GCP_PROJECT_ID".iam.gserviceaccount.com \
  --allow-unauthenticated \
  --port=8080 \
  --platform=managed