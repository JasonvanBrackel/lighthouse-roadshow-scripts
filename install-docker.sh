# (WIP) for full automated install
# Install Docker
k8s_nodes=./kubernetes-nodes
private_key_path=/home/jason/.ssh/id_rsa
admin=jason

# Keeping this for notes.  Can't work with out an interactive session
#cat $k8s_nodes | xargs -I% ssh -oStrictHostKeyChecking=no -i $private_key_path $admin@% "echo '$admin ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo"

cat $k8s_nodes | xargs -I% ssh -oStrictHostKeyChecking=no -i $private_key_path $admin@% "mkdir ~/.ssh"

cat $k8s_nodes | xargs -I%  scp ~/.ssh/id_rsa.pub  jason@%:/home/jason/.ssh/authorized_keys  

cat $k8s_nodes | xargs -I% ssh -oStrictHostKeyChecking=no -i $private_key_path $admin@% "curl https://releases.rancher.com/install-docker/17.03.sh | /bin/bash && sudo usermod -a -G docker $admin;"
