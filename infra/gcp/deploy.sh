#!/usr/bin/env bash

#
#  Script to deploy k33-web-gateway to GCP cloud run.
#

set -e

if [ -z "${BASH_VERSINFO}" ] || [ -z "${BASH_VERSINFO[0]}" ] || [ ${BASH_VERSINFO[0]} -lt 4 ]; then
  echo "This script requires Bash version >= 4"
  exit 1
fi

if [ -f .env ]; then
  set -o allexport
  source .env
  set +o allexport
fi

IMAGE=europe-docker.pkg.dev/"$GCP_PROJECT_ID"/web/k33-web-gateway/nginx:1.24.0-alpine

echo Pushing docker image

docker image build -t "$IMAGE" --platform linux/amd64 config
docker image push "$IMAGE"

echo Deploying to GCP cloud run

gcloud run deploy k33-web-gateway \
  --region europe-west1 \
  --image "$IMAGE" \
  --cpu=1 \
  --memory=512Mi \
  --min-instances=1 \
  --max-instances=1 \
  --concurrency=1000 \
  --set-env-vars=DEFAULT_HOSTNAME="$DEFAULT_HOSTNAME" \
  --set-env-vars=RESEARCH_HOSTNAME="$RESEARCH_HOSTNAME" \
  --set-env-vars=INVEST_HOSTNAME="$INVEST_HOSTNAME" \
  --set-env-vars=MARKETS_HOSTNAME="$MARKETS_HOSTNAME" \
  --set-env-vars=WEB_DOMAIN_NAME="$WEB_DOMAIN_NAME" \
  --set-env-vars=NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx/ \
  --service-account k33-web-gateway@"$GCP_PROJECT_ID".iam.gserviceaccount.com \
  --allow-unauthenticated \
  --ingress=internal-and-cloud-load-balancing \
  --port=8080 \
  --platform=managed