#!/bin/bash

# This script requires kubectl, kubectx, and kubens.
# Use cluster name as optional argument. 
# If argument is not passed, your current cluster will be used instead.

kubectx $1

kubens monitoring

echo "Getting prometheus-operator pods..."
kubectl get pods | grep prometheus-operator

pod=$(kubectl get pods | awk '{print $1}' | grep -e "prometheus-operator")
echo "Getting prometheus-operator logs..."
kubectl logs $pod -c prometheus-operator

read -p "Are you sure you want to rollout $pod? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Restarting the pods using rolling restart method..."
  kubectl rollout restart deployment prometheus-operator

  echo "Getting prometheus-operator pods..."
  kubectl get pods | grep prometheus-operator

  echo "Waiting 30 seconds for pod restart..."
  sleep 30

  echo "Getting prometheus-operator pods..."
  kubectl get pods | grep prometheus-operator

  new_pod=$(kubectl get pods | awk '{print $1}' | grep -e "prometheus-operator")
  echo "Getting new rolled prometheus-operator logs..."
  kubectl logs $new_pod -c prometheus-operator
fi
