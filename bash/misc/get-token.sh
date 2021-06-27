# grab a token for your .kube/config

kubectl -n kubernetes-dashboard get secret $(kubectl -n kubernetes-dashboard get sa/$1 -o jsonpath="{.secrets[0].name}") -o go-template="{{.data.token | base64decode}}" 
