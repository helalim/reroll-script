#!/bin/bash

# This script requires kubectl, kubectx, and kubens.
# This script takes in required argument of Node id. (Example: uw2d-fcp-build-1.infra.aws.dapt.to)

# Use cluster name as second optional argument. 
# If argument is not passed, your current cluster will be used instead.
# Use namespace as third optional argument. 
# If second argument is not passed, the monitoring namespace will be used instead.

if [ ! -z "$2" ]
  then
    ctx=$(kubectx $2 2>&1)
    echo $ctx
    if [[ $ctx == *"no context exists"* ]]; then
      exit 1
    fi
fi

if [ ! -z "$3" ]
  then
    namespace=$(kubens $3 2>&1)
    echo $namespace
    if [[ $namespace == *"no namespace exists"* ]]; then
      exit 1
    fi
else
  kubens monitoring
fi

if [ ! -z "$1" ]
  then
    # get node ID
    echo "Checking if given node exists..."
    
    echo $1
    if [[ $(kubectl get nodes | grep $1) ]]; then
      # describe node and grab EC2 instance ID
      # AWS way:
      # aws ec2 describe-instances --profile flagship-fcp-eng --region us-west-2 | grep "uw2d-fcp-build-1.infra.aws.dapt.to"
      # K8s way:
      # kubectl describe node | grep instance-id
      echo "Enter  AWS profile name:"
      read $profile
      echo "Using AWS profile: $profile."
      echo "Enter  region:"
      read $region
      echo "Using region: $region."
      # reboot instance
      aws ec2 reboot-instances --instance-ids i-1234567890abcdef5 --profile $profile --region $region
    fi
    exit 1
fi