#!/bin/bash

kubectl delete all --all --namespace emojivote
kubectl delete ingress --all --namespace emojivote
kubectl delete all --all --namespace argocd

echo "$(date) Finished destruction of resources"
