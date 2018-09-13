#!/bin/bash

# Create a project
project_name=gke-demo
project_id=gke-demo
cluster_name=gke-demo-cluster
zone=us-east1-b

gcloud projects create $project_id --name=$project_name
gcloud config set project $project_id

# Setup Billing
billing_account=gcloud alpha billing accounts list --format json | jq .[0].name | sed 's/billingAccounts\///'
gcloud beta billing projects link $project_id --billing-account=$billing_account

# Enable Google Compute Engine
# Enable Google Kubernetes Engine API
gcloud services enable compute.googleapis.com; gcloud services enable container.googleapis.com

# Create a Cluster
gcloud container clusters create $cluster_name -z $zone

# Get Cluster Configuration
gcloud container clusters get-credentials $cluster_name


