# Install Docker
k8s_nodes=./kubernetes-nodes
private_key_path=/home/jason/.ssh/id_rsa
admin=jason

cat $k8s_nodes | xargs -I% ssh -oStrictHostKeyChecking=no -i $private_key_path $admin@% "curl https://releases.rancher.com/install-docker/17.03.sh | /bin/bash && sudo usermod -a -G docker $admin;"
