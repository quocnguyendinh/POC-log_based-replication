# POC-log_based-replication
This is the POC for the log-based replication using the Meltano Tap-Postgres. 

Environment for testing: `Linux`, `Mac OS` but stable on `Linux`

## Steps to run:

1. Installing the environment: `bash environment-setup.sh`

2. If don't have infra, set up the infra: `make infra-init`

3. If want to stop infra but do not destroy them: `make infra-down`

4. If want to turn on the infra after suspending them: `make infra-up`

5. If want to completely destroy the infra: `make infra-shutdown`

6. If want to connect to postgres: `make connect-postgres`

7. If want to connect to clickhouse: `make connect-clickhouse`

8. If want to connect to duckdb: `make connect-duckdb`