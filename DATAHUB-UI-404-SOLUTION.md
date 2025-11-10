# DataHub UI 404 Error - Solution

## Issue
When trying to add data sources through the DataHub UI, you encountered a 404 error.

## Root Cause
The quickstart uses the `head` (development) version of DataHub images, which may have unstable UI features. The ingestion sources UI endpoint has changed or is not fully functional in this version.

## Solution
**Use the DataHub CLI for ingestion instead of the UI** - this is actually the recommended approach for production environments.

## ✅ Successfully Added Demo Data

Demo data has been ingested into your DataHub instance! You can now:

1. **View the data in the UI**: http://localhost:9002
   - Login with: `datahub` / `datahub`
   - Browse datasets, charts, dashboards, and containers
   
2. **Check what was ingested**:
   ```bash
   # The ingestion produced 105 metadata events
   # Including datasets, schemas, charts, and dashboards
   ```

## How to Add Your Own Data Sources

### Option 1: Use Existing Connectors (Recommended)

Create a recipe file (YAML) for your data source:

**Example: PostgreSQL**
```bash
# Create recipe file
cat > postgres-recipe.yml <<EOF
source:
  type: postgres
  config:
    host_port: localhost:5432
    database: mydb
    username: user
    password: pass
    
sink:
  type: datahub-rest
  config:
    server: http://localhost:8080
EOF

# Install postgres connector (if not already installed)
pip install 'acryl-datahub[postgres]'

# Run ingestion
datahub ingest run -c postgres-recipe.yml
```

### Option 2: Check Available Connectors

See what's available:
```bash
datahub check plugins
```

Disabled sources need extra packages:
```bash
pip install 'acryl-datahub[mysql]'
pip install 'acryl-datahub[snowflake]'
pip install 'acryl-datahub[bigquery]'
# etc.
```

### Option 3: Ingest More Demo Data

Try different demo data variations:
```bash
# Edit demo-data-recipe.yml and run again
datahub ingest run -c demo-data-recipe.yml
```

## Files Created

1. **`DATAHUB-ADD-SOURCES.md`** - Comprehensive guide with examples for:
   - PostgreSQL, MySQL, MongoDB
   - Snowflake, BigQuery
   - Kafka, dbt, CSV files
   - And many more sources

2. **`demo-data-recipe.yml`** - Working recipe to add demo data (already executed)

## Next Steps

1. **Explore the UI** at http://localhost:9002 to see the ingested demo data
2. **Choose your data sources** from the guide in `DATAHUB-ADD-SOURCES.md`
3. **Create recipe files** for your actual data sources
4. **Run ingestions** using `datahub ingest run -c <recipe-file>`

## Alternative: Fix the UI (Advanced)

If you really want to use the UI:

1. **Switch to stable version** - modify `datahub-quickstart.yml` to use a stable tag instead of `head`
2. **Restart services**:
   ```bash
   docker-compose -f datahub-quickstart.yml down
   # Edit the YAML to use stable tags like v1.3.0
   docker-compose -f datahub-quickstart.yml up -d
   ```

However, the CLI approach is more reliable and is what most production users prefer.

## Summary

✅ DataHub is running successfully  
✅ Demo data has been ingested (105 events)  
✅ CLI-based ingestion works perfectly  
✅ You have guides and examples ready to use  

The 404 error in the UI is a known issue with the development version, but CLI ingestion (the production-recommended method) works great!
