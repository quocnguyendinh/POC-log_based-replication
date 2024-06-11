FROM postgres:latest

RUN apt-get update && \
    apt-get upgrade -y

RUN apt-get update -y && \
    apt-get install -y curl ca-certificates && \
    install -d /usr/share/postgresql-common/pgdg && \
    curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
    sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    apt-get update -y && \
    apt-get install -y postgresql-server-dev-15 postgresql-15-wal2json && \
    rm -rf /var/lib/apt/lists/*
    
ENV PATH="/usr/lib/postgresql/15/bin:${PATH}"

RUN sed -i 's/#*.*log_statement.*/log_statement = \'insert\'/' /etc/postgresql/15/main/postgresql.conf && \
    sed -i 's/#*.*wal_level.*/wal_level = logical/' /etc/postgresql/15/main/postgresql.conf && \
    sed -i 's/#*.*max_replication_slots.*/max_replication_slots = 10/' /etc/postgresql/15/main/postgresql.conf && \
    sed -i 's/#*.*max_wal_senders.*/max_wal_senders = 10/' /etc/postgresql/15/main/postgresql.conf

RUN service postgresql restart && \
    PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -h localhost -c "SELECT * FROM pg_create_logical_replication_slot('tappostgres', 'wal2json');"

EXPOSE 5432

CMD ["postgres"]