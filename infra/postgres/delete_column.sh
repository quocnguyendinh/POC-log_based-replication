docker exec -i log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" << EOF
ALTER TABLE sample DROP COLUMN new_column;
INSERT INTO sample (text_field, nested_json) VALUES ('DROP COLUMN', '{"type": "animal"}');
EOF
