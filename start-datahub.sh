#!/bin/bash

set -e

echo "Starting DataHub locally with Docker Compose..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Pull latest images
echo "Pulling latest DataHub images..."
docker-compose -f datahub-quickstart.yml pull

# Start all services
echo "Starting all DataHub services..."
docker-compose -f datahub-quickstart.yml up -d

# Wait for services to be healthy
echo "Waiting for services to be ready..."
echo "This may take a few minutes on first startup..."

max_wait=300
elapsed=0
while [ $elapsed -lt $max_wait ]; do
    if docker-compose -f datahub-quickstart.yml ps | grep -q "unhealthy"; then
        echo "Waiting for unhealthy services... ($elapsed seconds)"
        sleep 10
        elapsed=$((elapsed + 10))
    elif docker-compose -f datahub-quickstart.yml ps datahub-frontend-react | grep -q "Up"; then
        echo "DataHub is ready!"
        echo ""
        echo "Access DataHub at: http://localhost:9002"
        echo "Default credentials:"
        echo "  Username: datahub"
        echo "  Password: datahub"
        echo ""
        echo "API endpoint: http://localhost:8080"
        echo ""
        echo "To view logs: docker-compose -f datahub-quickstart.yml logs -f"
        echo "To stop: docker-compose -f datahub-quickstart.yml down"
        echo "To stop and remove data: docker-compose -f datahub-quickstart.yml down -v"
        exit 0
    else
        echo "Services starting... ($elapsed seconds)"
        sleep 10
        elapsed=$((elapsed + 10))
    fi
done

echo "Warning: Services took longer than expected to start."
echo "Check status with: docker-compose -f datahub-quickstart.yml ps"
echo "Check logs with: docker-compose -f datahub-quickstart.yml logs"
