#!/bin/bash

set -e

echo "Installing DataHub CLI and starting quickstart..."

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not found"
    exit 1
fi

# Install DataHub CLI
echo "Installing acryl-datahub..."
python3 -m pip install --upgrade acryl-datahub

# Run DataHub quickstart
echo "Starting DataHub quickstart (this will take a few minutes)..."
datahub docker quickstart

echo ""
echo "DataHub should now be accessible at: http://localhost:9002"
echo "Default credentials:"
echo "  Username: datahub"
echo "  Password: datahub"
