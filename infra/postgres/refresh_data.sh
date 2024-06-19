# Insert sample data into the sample table
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
GRANT ALL ON sample TO $MELTANO_POSTGRES_USER;
EOF
