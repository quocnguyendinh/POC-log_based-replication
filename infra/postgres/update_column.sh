echo "Wating for the tranasaction to finish..."
docker exec -i log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" << EOF
ALTER TABLE sample ADD COLUMN new_column int;
INSERT INTO sample (text_field, nested_json, new_column) VALUES ('UPDATE COLUMN', '{"type": "animal"}', 3);
EOF
