#!/bin/bash

# This script requires kubectl, kubectx, and kubens.
# Use cluster name as optional argument. 
# If argument is not passed, your current cluster will be used instead.
# Use namespace as second optional argument. 
# If second argument is not passed, the monitoring namespace will be used instead.

if [ ! -z "$1" ]
  then
    ctx=$(kubectx $1 2>&1)
    echo $ctx
    if [[ $ctx == *"no context exists"* ]]; then
      exit 1
    fi
fi

if [ ! -z "$2" ]
  then
    namespace=$(kubens $2 2>&1)
    echo $namespace
    if [[ $namespace == *"no namespace exists"* ]]; then
      exit 1
    fi
else
  kubens monitoring
fi

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
