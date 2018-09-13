#!/bin/bash

# Create a project
echo "Creating a Project."
project_name=gke-demo
project_id=gke-demo-$RANDOM
cluster_name=gke-demo-cluster
zone=us-east1-b

gcloud projects create $project_id --name=$project_name
gcloud config set project $project_id

# Setup Billing
billing_account=$(gcloud alpha billing accounts list --format="value[](name.basename():label=ACCOUNT_ID)")
gcloud beta billing projects link $project_id --billing-account=$billing_account

echo "Enabling Compute & Kubernetes Services."
# Enable Google Compute Engine
# Enable Google Kubernetes Engine API
gcloud services enable compute.googleapis.com; gcloud services enable container.googleapis.com

# Create a Cluster
echo "Creating a Cluster."
gcloud container clusters create $cluster_name -z $zone --no-async

# Get Cluster Configuration
echo "Getting Cluster Credentials."
gcloud container clusters get-credentials $cluster_name
