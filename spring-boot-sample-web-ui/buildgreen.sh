#!/bin/bash
  
  
# bluegreen.sh <servicename> <version> <green-deployment.yaml>
# ex, ./bluegreen.sh orders dev orders-dep.yaml
# Deployment name should be <service>-<version>
  
SERVICE=$1
VERSION=$2
DEPLOYMENTFILE=$3
  
kubectl apply -f $DEPLOYMENTFILE
  
POD=$(kubectl get pod --selector version=dev -o jsonpath="{.items[0].metadata.name}”)
  
# Wait until the Deployment is ready by checking the MinimumReplicasAvailable condition.
READY=$(kubectl describe po $POD | awk '/Ready:/ {print $2}')
while [[ "$READY" != "True" ]]; do
    READY=$(kubectl describe po $POD | awk '/Ready:/ {print $2}')
    sleep 5
done
  
# Update the service selector with the new version
kubectl patch svc $SERVICE -n sock-shop -p "{\"spec\":{\"selector\": {\"name\": \"${SERVICE}-dev\", \"version\": \"${VERSION}\"}}}"
  
echo "Done."
