#!/bin/bash

ip_argo=$(kubectl get service argocd-server -n argocd -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

passwd_argo=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo)

if [ -z "$passwd_argo" ]
then
  echo "\$passwd_argo is empty"
  passwd_argo=qlo
else
  echo "\$passwd_argo is NOT empty"
  passwd_argo=qlo
fi

echo $passwd_argo

while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' https://${ip_argo} --insecure)" != "200" ]]; do sleep 5; done