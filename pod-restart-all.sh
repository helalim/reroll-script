#!/bin/bash

# This script requires kubectl, kubectx, and kubens.
# This script checks all the clusters for the given error and only restarts
# pods when such error is found.

kubectx > ctx.txt

cat ctx.txt | while read line; do

  kubectx $line
  kubens monitoring


  echo "Getting prometheus-operator pods..."
  kubectl get pods | grep prometheus-operator

  pod=$(kubectl get pods | awk '{print $1}' | grep -e "prometheus-operator")
  echo "Getting prometheus-operator logs..."
  kubectl logs $pod -c prometheus-operator

  logs=$(kubectl logs $pod -c prometheus-operator 2>&1)
  if [[ $logs == *"TLS handshake error"* ]]; then
    echo "Detected a common TLS handshake error. Re-rolling the pods will fix this. Auto-reroll will start in 10 seconds. use CTRL+C to cancel..."
    sleep 10
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
done
