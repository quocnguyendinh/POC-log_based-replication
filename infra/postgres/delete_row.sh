docker exec -i log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" << EOF
DELETE FROM sample WHERE id = 1;
EOF
