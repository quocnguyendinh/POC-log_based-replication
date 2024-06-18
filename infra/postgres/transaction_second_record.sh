export POSTGRES_USER=meltano
export POSTGRES_DB=meltano

echo "Wating for the tranasaction to finish..."
docker exec -i log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" << EOF
BEGIN;
SELECT current_timestamp;
INSERT INTO sample (text_field, nested_json)
VALUES
    ('record 2', '{"description": "This record was created LATER but flushed into the DB FIRST"}');
SELECT pg_sleep(60);
SELECT current_timestamp;
COMMIT;
EOF