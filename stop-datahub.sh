#!/bin/bash

set -e

echo "Stopping DataHub services..."
docker-compose -f datahub-quickstart.yml down

echo "DataHub stopped successfully."
echo ""
echo "To remove all data and volumes, run: docker-compose -f datahub-quickstart.yml down -v"
