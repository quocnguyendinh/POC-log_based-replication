#!/bin/bash

# Set environment variables
export POSTGRES_USER=meltano
export POSTGRES_DB=meltano
export CLICKHOUSE_USER=meltano
export CLICKHOUSE_PASS=meltano

# Restart the PostgreSQL container
docker restart log_based_postgres

echo "Sleeping for 10 seconds for the server to restart..."
sleep 10

# Create logical replication slot
docker exec -it log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT * FROM pg_create_logical_replication_slot('tappostgres', 'wal2json');"

# Create the sample table
bash postgres/refresh_data.sh

docker exec -it clickhouse clickhouse-client -u $CLICKHOUSE_USER --password $CLICKHOUSE_PASS -q "CREATE DATABASE meltano;"