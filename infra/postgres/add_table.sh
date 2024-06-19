docker exec -i log_based_postgres psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" << EOF
DROP TABLE IF EXISTS sample_2;
CREATE TABLE IF NOT EXISTS sample_2 (
    id SERIAL PRIMARY KEY,
    text_field TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO sample_2 (text_field) VALUES ('cat'), ('dog');
EOF