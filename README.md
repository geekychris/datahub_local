<p align="center">
  <img src="assets/logo.png" alt="Datahub Local logo" width="180">
</p>

# DataHub Setup

**Note:** This directory has been reorganized. All DataHub files are now in the `datahub/` directory, and we're using the official DataHub quickstart configuration.

This directory contains scripts to run LinkedIn's DataHub locally using either Docker Compose or Kubernetes.

## What is DataHub?

DataHub is LinkedIn's open-source metadata platform for the modern data stack. It helps you discover, understand, and trust your data assets.

## Prerequisites

### For Docker Compose
- Docker Desktop installed and running
- At least 8GB RAM allocated to Docker

### For Kubernetes
- Kubernetes cluster (Docker Desktop with Kubernetes enabled, minikube, or kind)
- kubectl installed and configured

## Running with Docker Compose (Recommended for local development)

### Option 1: Using DataHub CLI Quickstart (Easiest)
```bash
./quickstart-datahub.sh
```

This installs the DataHub CLI and runs the official quickstart which handles ARM/Apple Silicon compatibility automatically.

### Option 2: Using Docker Compose directly
```bash
chmod +x start-datahub.sh
./start-datahub.sh
```

**Note**: If you're on Apple Silicon (M1/M2/M3), you may encounter compatibility issues with some DataHub images. In that case, use Option 1 instead.

This will:
- Pull all required Docker images
- Start PostgreSQL, Elasticsearch, Kafka, and DataHub services
- Wait for all services to be healthy
- Display access information

### Access DataHub
- Web UI: http://localhost:9002
- API: http://localhost:8080
- Default credentials:
  - Username: `datahub`
  - Password: `datahub`

### Manage Services
```bash
# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f datahub-frontend

# Check service status
docker-compose ps

# Stop services
./stop-datahub.sh
# or
docker-compose down

# Stop and remove all data
docker-compose down -v
```

## Running with Kubernetes

### Deploy to Kubernetes
```bash
chmod +x deploy-k8s.sh
./deploy-k8s.sh
```

### Access DataHub

The Kubernetes deployment uses NodePort, so services are directly accessible:

- **DataHub Frontend**: http://localhost:30002
- **DataHub GMS API**: http://localhost:30080  
- **Elasticsearch**: http://localhost:30920
- **Kafka**: localhost:30909
- **PostgreSQL**: localhost:30432
- **Zookeeper**: localhost:30218
- **Schema Registry**: http://localhost:30808

Alternatively, use port forwarding:
```bash
kubectl port-forward -n datahub svc/datahub-frontend 9002:9002
```

Then open http://localhost:9002 in your browser.

### Manage Deployment
```bash
# Check pod status
kubectl get pods -n datahub

# View logs
kubectl logs -n datahub -l app=datahub-frontend

# Delete deployment
kubectl delete namespace datahub
```

## Components

The setup includes:
- **PostgreSQL**: Metadata storage database
- **Elasticsearch**: Search and indexing
- **Kafka + Zookeeper**: Event streaming and message queue
- **Schema Registry**: Schema management for Kafka
- **DataHub GMS**: Generalized Metadata Service (backend API)
- **DataHub Frontend**: React-based web UI
- **DataHub Actions**: Automation framework (optional)

## Resource Requirements

- **Minimum**: 8GB RAM, 4 CPU cores
- **Recommended**: 16GB RAM, 8 CPU cores

## Troubleshooting

### Services won't start
- Check Docker has enough resources allocated
- Run `docker-compose logs` to see error messages

### Elasticsearch fails with "max virtual memory areas vm.max_map_count too low"
```bash
# On Linux
sudo sysctl -w vm.max_map_count=262144

# On macOS with Docker Desktop, this is usually not needed
```

### Port conflicts
If ports 5432, 9200, 9092, 8080, or 9002 are already in use, modify the port mappings in `docker-compose.yml`.

### Reset everything
```bash
docker-compose down -v
docker system prune -a
./start-datahub.sh
```

## Next Steps

After DataHub is running:
1. Log in with default credentials (datahub/datahub)
2. Install the DataHub CLI: `pip install acryl-datahub`
3. Ingest metadata from your data sources
4. Explore the DataHub documentation: https://datahubproject.io/

## Security Notes

**Important**: This setup is for local development only. For production:
- Change all default passwords
- Enable authentication and authorization
- Use managed services for databases
- Configure proper secrets management
- Enable TLS/SSL
- Review DataHub's production deployment guide
