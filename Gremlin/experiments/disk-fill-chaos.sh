#!/bin/bash

NAMESPACE="sock-shop"
APP_LABEL="front-end"
FILL_SIZE_MB=3000
IMAGE="busybox"

echo "🔍 Getting front-end pod in namespace $NAMESPACE..."
POD_NAME=$(kubectl get pods -n $NAMESPACE -l name=$APP_LABEL -o jsonpath="{.items[0].metadata.name}")

if [ -z "$POD_NAME" ]; then
  echo "❌ Could not find the front-end pod. Exiting."
  exit 1
fi

echo "✅ Found pod: $POD_NAME"

echo "🚀 Injecting ephemeral container to simulate disk fill..."
kubectl debug -n $NAMESPACE -it $POD_NAME --image=$IMAGE --target=$APP_LABEL --name=disk-fill -- /bin/sh -c "dd if=/dev/zero of=/tmp/fillfile bs=1M count=$FILL_SIZE_MB; echo '✅ Disk fill complete'; sleep 300" &

sleep 5

echo "📊 Watching pod behavior for 2 minutes..."
kubectl get pods -n $NAMESPACE $POD_NAME -w --timeout=120s

echo "📝 Describe pod:"
kubectl describe pod $POD_NAME -n $NAMESPACE | grep -A 10 "Ephemeral Containers"

echo "📉 Logs from front-end pod:"
kubectl logs $POD_NAME -n $NAMESPACE | tail -n 20

read -p "🧹 Do you want to cleanup and restart the pod? (y/n): " CLEANUP
if [[ "$CLEANUP" == "y" ]]; then
  echo "♻️ Restarting front-end deployment..."
  kubectl rollout restart deployment/$APP_LABEL -n $NAMESPACE
fi

echo "✅ Chaos test script completed."

