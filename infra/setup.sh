#!/bin/bash

# Restart the PostgreSQL container
docker restart log_based_postgres

echo "Sleeping for 10 seconds for the server to restart..."
sleep 10

# Create logical replication slot
docker exec -it log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT * FROM pg_create_logical_replication_slot('tappostgres', 'wal2json');"

# Create the sample table
docker exec -i log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" << EOF
DROP TABLE IF EXISTS sample;
CREATE TABLE IF NOT EXISTS sample (
    id SERIAL PRIMARY KEY,
    text_field TEXT,
    nested_json JSONB,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO sample (text_field, nested_json)
VALUES
    ('cat', '{"type": "animal", "subtype": {"type": "mammal"}}'),
    ('dog', '{"type": "animal"}');

CREATE ROLE $MELTANO_POSTGRES_USER LOGIN PASSWORD '$MELTANO_POSTGRES_PASS';
GRANT ALL ON sample TO $MELTANO_POSTGRES_USER;
ALTER ROLE meltano_postgres WITH REPLICATION;
EOF

docker exec -it clickhouse clickhouse-client -u $CLICKHOUSE_USER --password $CLICKHOUSE_PASS -q "CREATE DATABASE meltano;"