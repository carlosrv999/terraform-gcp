#!/bin/bash

kubectl delete ingress --all --namespace emojivote
kubectl delete svc --all --namespace argocd

echo "$(date) Finished destruction of resources"
