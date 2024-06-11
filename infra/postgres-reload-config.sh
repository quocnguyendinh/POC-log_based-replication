#!/bin/bash

# Set environment variables
export POSTGRES_USER=meltano
export POSTGRES_DB=meltano

# Restart the PostgreSQL container
docker restart log_based_postgres

echo "Sleeping for 10 seconds for the server to restart..."
sleep 10

# Create logical replication slot
docker exec -it log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT * FROM pg_create_logical_replication_slot('tappostgres', 'wal2json');"

# Create the sample table
docker exec -it log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "
CREATE TABLE IF NOT EXISTS sample (
    id SERIAL PRIMARY KEY,
    uuid INTEGER GENERATED ALWAYS AS IDENTITY,
    text_field TEXT,
    nested_json JSONB
);
"

# Insert sample data into the sample table
docker exec -i log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" << EOF
INSERT INTO sample (text_field, nested_json)
VALUES
    ('cat', '{"type": "animal", "subtype": {"type": "mammal"}}'),
    ('dog', '{"type": "animal"}');
EOF
