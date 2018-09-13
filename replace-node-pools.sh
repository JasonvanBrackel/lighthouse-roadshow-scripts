#!/bin/sh
cluster_name=c-qgrfw
zone=us-central1-f
old_nodepool=default-pool
new_nodepool=marketplace-compatible

# Create new node pool
gcloud container node-pools create $new_nodepool \
   --cluster $cluster_name --zone $zone \
   --num-nodes 3 \
   --scopes=https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/devstorage.full_control,https://www.googleapis.com/auth/service.management,https://www.googleapis.com/auth/trace.append

# Cordon off the old nodes
kubectl cordon -l cloud.google.com/gke-nodepool=$old_nodepool

# Drain the old nodes
kubectl drain -l cloud.google.com/gke-nodepool=$old_nodepool --force --ignore-daemonsets

# Remove the old node pool
gcloud container node-pools delete $old_nodepool \
   --cluster $cluster_name --zone $zone
   