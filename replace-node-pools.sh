#!/bin/sh
cluster_name=<Your Cluster Name>
zone=<Your Cluster Zone>
old_nodepool=default-pool
new_nodepool=marketplace-compatible

# Create new node pool
gcloud container node-pools create $new_nodepool \
   --cluster $cluster_name --zone $zone \
   --num-nodes 3 \
   --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/compute,https://www.googleapis.com/auth/cloud-platform,https://www.googleapis.com/auth/devstorage.full_control,https://www.googleapis.com/auth/service.management,https://www.googleapis.com/auth/trace.append,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring

# Cordon off the old nodes
kubectl cordon -l cloud.google.com/gke-nodepool=$old_nodepool

# Drain the old nodes
kubectl drain -l cloud.google.com/gke-nodepool=$old_nodepool --force --ignore-daemonsets

# Remove the old node pool
gcloud container node-pools delete $old_nodepool \
   --cluster $cluster_name --zone $zone
   