#!/bin/sh

# Service Account
serviceaccount="admin-user"

kubectl -n kube-system create serviceaccount $serviceaccount

# Cluster Role Binding
cat <<EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: $serviceaccount-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: $serviceaccount
  namespace: kube-system
EOF

secret="$(kubectl -n kube-system get serviceaccount "$serviceaccount" -o 'jsonpath={.secrets[0].name}' 2>/dev/null)"

# Context
context="$(kubectl config current-context)"

# Cluster
cluster="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"$context\")].context.cluster}")"
server="$(kubectl config view -o "jsonpath={.clusters[?(@.name==\"$cluster\")].cluster.server}")"

# Token
ca_crt_data="$(kubectl -n kube-system get secret "$secret" -o "jsonpath={.data.ca\.crt}" | openssl enc -d -base64 -A)"
namespace="$(kubectl -n kube-system get secret "$secret" -o "jsonpath={.data.namespace}" | openssl enc -d -base64 -A)"
token="$(kubectl -n kube-system get secret "$secret" -o "jsonpath={.data.token}" | openssl enc -d -base64 -A)"

# Config
export KUBECONFIG="$(mktemp)"
kubectl config set-credentials "$serviceaccount" --token="$token" >/dev/null
ca_crt="$(mktemp)"; echo "$ca_crt_data" > $ca_crt
kubectl config set-cluster "$cluster" --server="$server" --certificate-authority="$ca_crt" --embed-certs >/dev/null
kubectl config set-context "$context" --cluster="$cluster" --namespace="$namespace" --user="$serviceaccount" >/dev/null
kubectl config use-context "$context" >/dev/null

cat "$KUBECONFIG"

# Rancher Import
### INSERT RANCHER IMPORT COMMAND HERE


rm $KUBECONFIG
unset KUBECONFIG
kubectl -n kube-system delete ClusterRoleBinding $serviceaccount-binding
kubectl -n kube-system delete serviceaccount $serviceaccount