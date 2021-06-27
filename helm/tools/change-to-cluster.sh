aws eks update-kubeconfig --region $1 --name $2 && chmod 600 ~/.kube/config
