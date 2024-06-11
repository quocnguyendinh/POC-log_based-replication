export POSTGRES_USER=meltano
export POSTGRES_DB=meltano

docker restart log_based_postgres

echo "sleep 10s for the server to restart..."
sleep 10

docker exec -it log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "SELECT * FROM pg_create_logical_replication_slot('tappostgres', 'wal2json');"