#!/bin/bash

region=$1
cluster_name=$2

# SCRIPT PARA INSTALAR ARGOCD EN EL CLUSTER RECIEN CREADO POR TERRAFORM

# Setear kubeconfig
gcloud container clusters get-credentials $cluster_name --region $region

# Crear namespace para Argo CD, luego instalarlo
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Publicamos el ArgoCD por un balanceador de carga:
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

ip_argo=$(kubectl get service argocd-server -n argocd -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Esperar hasta que se le asigne una IP publica al servicio LoadBalancer
while [ -z "$ip_argo" ]
do
  ip_argo=$(kubectl get service argocd-server -n argocd -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
  echo "Esperando 3 segundos mas para que la IP del balanceador se setee"
  sleep 3
done

# Esperar hasta que el LoadBalancer service de Argo responda con 200
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' https://${ip_argo} --insecure)" != "200" ]]; do sleep 5; done

# Obtener la contrasenia de Argo y hacer login
passwd_argo=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)
argocd login $ip_argo --username admin --password $passwd_argo --insecure

context_current=$(kubectl config current-context)

# Agregar contexto de Argo
argocd cluster add $context_current -y

# Crear namespace emojivote
kubectl create namespace emojivote

# Crear aplicacion de Argo
argocd app create emojivote --repo https://github.com/carlosrv999/terraform-gcp.git --path manifests-voteapp --dest-server https://kubernetes.default.svc --dest-namespace emojivote --directory-recurse

# Sincronizar app emojivote
argocd app sync emojivote
