docker exec -i log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" << EOF
REVOKE SELECT ON sample from $MELTANO_POSTGRES_PASS;
EOF