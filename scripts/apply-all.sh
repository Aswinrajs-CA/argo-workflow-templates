#!/bin/bash
set -e

NAMESPACE=${1:-argo}

echo "Applying Argo Workflow Templates to namespace: $NAMESPACE"
echo ""

echo ">> Applying WorkflowTemplates..."
for f in templates/*.yaml; do
    echo "   Applying $f"
    kubectl apply -f "$f" -n "$NAMESPACE"
done

echo ""
echo "All templates applied successfully!"
echo ""
echo "Run a sample workflow:"
echo "  kubectl create -f workflows/sample-pipeline.yaml -n $NAMESPACE"
echo "  kubectl create -f workflows/etl-pipeline.yaml -n $NAMESPACE"
echo "  kubectl create -f dag-examples/ml-pipeline.yaml -n $NAMESPACE"
echo ""
echo "Watch workflow status:"
echo "  kubectl get workflows -n $NAMESPACE -w"
