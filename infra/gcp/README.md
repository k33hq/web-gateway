# Infra setup

## Install and initialize `gcloud`  

Ref: https://cloud.google.com/sdk/docs/quickstart  
Ref: https://cloud.google.com/sdk/docs/initializing  
```shell
gcloud components update

gcloud auth login
gcloud config set project $GCP_PROJECT_ID
gcloud config set compute/region europe-west1
gcloud config set compute/zone europe-west1-b
gcloud config set run/region europe-west1
# or
gcloud init
```

Output of `gcloud config list`
```text
[compute]
region = europe-west1
zone = europe-west1-b
[core]
account = user@arcane.no
disable_usage_reporting = True
project = <<GCP_PROJECT_ID>
[run]
region = europe-west1

Your active configuration is: [default]
```

Create service accounts for both the cloud run services.
```shell
gcloud iam service-accounts create k33-web-gateway \
    --description="Service Account for k33-web-gateway cloud run service" \
    --display-name="k33-web-gateway"
```

Deploy `k33-web-gateway` to GCP Cloud Run

```shell
./infra/gcp/deploy.sh
```

Assign domain name to gateway

```shell
gcloud beta run domain-mappings create --service k33-web-gateway --domain "${WEB_DOMAIN_NAME}"
```