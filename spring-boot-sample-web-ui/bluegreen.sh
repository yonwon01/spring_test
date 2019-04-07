#!/bin/bash


# bluegreen.sh <servicename> <version> <green-deployment.yaml>
# ex, ./bluegreen.sh messages-service opr green-deploy.yaml

SERVICE=$1
VERSION=$2
DEPLOYMENTFILE=$3

kubectl apply -f $DEPLOYMENTFILE

POD=$(kubectl get pod --selector version=$VERSION -o jsonpath={.items[0].metadata.name})
echo $POD
# Wait until the Deployment is ready by checking the MinimumReplicasAvailable condition.
READY=$(kubectl describe po $POD | awk '/Ready:/ {print $2}')
while [[ "$READY" != "True" ]]; do
    READY=$(kubectl describe po $POD | awk '/Ready:/ {print $2}')
    echo $READY
    sleep 5
done

# Update the service selector with the new version
kubectl patch svc $SERVICE -p '{"spec":{"selector":{"name":"messages","version":"opr"}}}'
echo $SERVICE
echo "Done"
