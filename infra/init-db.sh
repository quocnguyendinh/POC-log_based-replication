#!/bin/bash
set -e

# Wait for PostgreSQL to start
until pg_isready; do
  echo "Waiting for PostgreSQL to start..."
  sleep 2
done

# Copy the custom configuration file
cp /docker-entrypoint-initdb.d/custom-postgresql.conf /var/lib/postgresql/data/postgresql.conf

# Create the logical replication slot
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT * FROM pg_create_logical_replication_slot('tappostgres', 'wal2json');"
