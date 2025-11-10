# Adding Data Sources to DataHub

The UI ingestion sources feature may have issues in the current version. The recommended approach is to use the DataHub CLI to ingest metadata.

## Prerequisites

The DataHub CLI is already installed. Verify with:
```bash
datahub version
```

## Method 1: Create Ingestion Recipe (Recommended)

### 1. Create a Recipe File

Create a YAML file describing your data source. Here's an example for PostgreSQL:

**postgres-recipe.yml:**
```yaml
source:
  type: postgres
  config:
    host_port: localhost:5432
    database: your_database
    username: your_username
    password: your_password
    
sink:
  type: datahub-rest
  config:
    server: http://localhost:8080
```

### 2. Run the Ingestion

```bash
datahub ingest -c postgres-recipe.yml
```

## Method 2: Common Data Source Examples

### MySQL
```yaml
source:
  type: mysql
  config:
    host_port: localhost:3306
    database: your_database
    username: your_username
    password: your_password
    
sink:
  type: datahub-rest
  config:
    server: http://localhost:8080
```

### Snowflake
```yaml
source:
  type: snowflake
  config:
    account_id: your_account
    username: your_username
    password: your_password
    warehouse: your_warehouse
    role: your_role
    
sink:
  type: datahub-rest
  config:
    server: http://localhost:8080
```

### BigQuery
```yaml
source:
  type: bigquery
  config:
    project_id: your_project_id
    
sink:
  type: datahub-rest
  config:
    server: http://localhost:8080
```

### MongoDB
```yaml
source:
  type: mongodb
  config:
    connect_uri: mongodb://localhost:27017
    username: your_username
    password: your_password
    
sink:
  type: datahub-rest
  config:
    server: http://localhost:8080
```

### CSV Files
```yaml
source:
  type: csv-enricher
  config:
    filename: ./path/to/your/file.csv
    
sink:
  type: datahub-rest
  config:
    server: http://localhost:8080
```

### dbt
```yaml
source:
  type: dbt
  config:
    manifest_path: ./target/manifest.json
    catalog_path: ./target/catalog.json
    target_platform: snowflake
    
sink:
  type: datahub-rest
  config:
    server: http://localhost:8080
```

### Kafka
```yaml
source:
  type: kafka
  config:
    connection:
      bootstrap: localhost:9092
      
sink:
  type: datahub-rest
  config:
    server: http://localhost:8080
```

## Method 3: Test with Sample Data

DataHub provides sample ingestion to test the system:

```bash
# Ingest sample data
datahub docker ingest-sample-data
```

## Method 4: List Available Sources

See all available source types:

```bash
datahub ingest list-sources
```

Get details about a specific source:

```bash
datahub ingest get-source-details --source-type postgres
```

## Checking Ingestion Status

After running ingestion, check the UI at http://localhost:9002 to see your ingested datasets.

You can also check via CLI:

```bash
# List all datasets
datahub get --urn "urn:li:dataset:(urn:li:dataPlatform:postgres,your_database.your_schema.your_table,PROD)"
```

## Troubleshooting

### Connection Issues
- Ensure your data source is accessible from the DataHub container
- For localhost sources, use `host.docker.internal` instead of `localhost` in recipes

### Authentication Errors
- Verify credentials are correct
- Check if the user has necessary permissions

### Missing Dependencies
Some sources require additional Python packages:

```bash
# Install source-specific requirements
pip install 'acryl-datahub[postgres]'
pip install 'acryl-datahub[mysql]'
pip install 'acryl-datahub[snowflake]'
pip install 'acryl-datahub[bigquery]'
```

## Advanced: Scheduled Ingestion

For production use, set up scheduled ingestion using cron or a workflow scheduler:

```bash
# Example cron job (every day at 2 AM)
0 2 * * * cd /path/to/recipes && datahub ingest -c postgres-recipe.yml
```

## UI Workaround

If you want to use the UI but it's showing 404:

1. **Option 1**: Use a stable release instead of `head` version
2. **Option 2**: Use the DataHub Actions feature to set up ingestion
3. **Option 3**: Wait for the UI feature to stabilize in the development version

For now, the CLI approach is more reliable and commonly used in production environments.

## More Information

- DataHub Sources: https://datahubproject.io/docs/metadata-ingestion/
- Recipe Examples: https://github.com/datahub-project/datahub/tree/master/metadata-ingestion/examples/recipes
- CLI Documentation: https://datahubproject.io/docs/cli/
