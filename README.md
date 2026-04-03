# Argo Workflow Templates

A collection of reusable Argo Workflow Templates for Kubernetes-native pipelines.

## Structure

```
.
├── templates/           # Reusable WorkflowTemplates (CRDs)
│   ├── hello-world.yaml
│   ├── data-processing.yaml
│   └── notification.yaml
├── workflows/           # Workflows that reference templates
│   ├── sample-pipeline.yaml
│   └── etl-pipeline.yaml
├── dag-examples/        # DAG-based workflow examples
│   └── ml-pipeline.yaml
└── scripts/             # Helper scripts
    └── apply-all.sh
```

## Prerequisites

- Kubernetes cluster
- Argo Workflows installed (`kubectl apply -f https://github.com/argoproj/argo-workflows/releases/latest/download/install.yaml`)
- `kubectl` configured

## Quick Start

```bash
# Apply all templates
./scripts/apply-all.sh

# Or apply individually
kubectl apply -f templates/
kubectl apply -f workflows/
```

## Template Types

| Template | Description |
|----------|-------------|
| `hello-world` | Basic container template |
| `data-processing` | Script-based data transform |
| `notification` | Send alerts/notifications |
| `ml-pipeline` | DAG-based ML training pipeline |
