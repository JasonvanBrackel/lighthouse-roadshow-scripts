helm_version="v2.10.0"
rancher_hostname="rancher.vanbrackel.net"


# Install Helm and Setup Tiller
# Download Helm
if [ ! -f "./linux-amd64/helm" ]; then
    echo "Helm not found.  Downloading."
    wget https://storage.googleapis.com/kubernetes-helm/helm-$helm_version-linux-amd64.tar.gz
    tar -xvzf ./helm-$helm_version-linux-amd64.tar.gz
else
    helm_client_version=$(./linux-amd64/helm version -c --short)
    if [[ $helm_client_version = *"$helm_version"* ]]
    then
        echo "Helm version is $helm_client_version.  Continuing."
    else
        echo "Helm version is not $helm_version.  Downloading."
        rm -rf ./linux-amd64
        wget https://storage.googleapis.com/kubernetes-helm/helm-$helm_version-linux-amd64.tar.gz
        tar -xvzf ./helm-$helm_version-linux-amd64.tar.gz
    fi
fi

kubectl config set-context Default

# Setup Tiller
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller \
  --clusterrole cluster-admin \
  --serviceaccount=kube-system:tiller

./linux-amd64/helm init --service-account tiller 

# Install Rancher
./linux-amd64/helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

sleep 10s

# Optional: Install Cert-Manager if you're using self-signed certificates or Let's Encrypt certificates.
./linux-amd64/helm install stable/cert-manager \
  --name cert-manager \
  --namespace kube-system 

# Install Rancher
./linux-amd64/helm install rancher-stable/rancher \
  --name rancher \
  --namespace cattle-system \
  --set hostname=$rancher_hostname
