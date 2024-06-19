docker exec -i log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" << EOF
ALTER TABLE sample ADD COLUMN new_column TEXT;
INSERT INTO sample (text_field, nested_json, new_column) VALUES ('ADD COLUMN', '{"type": "animal"}', 'new column test');
EOF
