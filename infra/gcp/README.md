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
gcloud iam service-accounts create arcane-web-proxy \
    --description="Service Account for arcane-web-proxy cloud run service" \
    --display-name="arcane-web-proxy"
```

Assign role to service account so that it can access GCP Secret manager.
```shell
gcloud projects add-iam-policy-binding "$GCP_PROJECT_ID" \
  --member serviceAccount:arcane-web-proxy@"$GCP_PROJECT_ID".iam.gserviceaccount.com \
  --role roles/secretmanager.secretAccessor
```
