infra-up:
	docker-compose -f ./infra/docker-compose.yml up -d

infra-down:
	docker-compose -f ./infra/docker-compose.yml stop

infra-init: infra-up
	cd infra && bash ./duck-db-setup.sh
	cd meltano && poetry run meltano install -f
	bash ./infra/setup.sh 

infra-shutdown:
	find infra -type f -name "*duckdb*" -delete
	cd meltano && rm -rf .meltano
	docker-compose -f ./infra/docker-compose.yml down

infra-restart:
	docker-compose -f ./infra/docker-compose.yml restart

connect-postgres:
	docker exec -it log_based_postgres psql -U "meltano" -d "meltano"

connect-postgres-sub-user:
	docker exec -it log_based_postgres psql -U "meltano_postgres" -d "meltano"

connect-clickhouse:
	docker exec -it clickhouse clickhouse-client -u meltano --password meltano --database meltano

connect-duckdb:
	duckdb infra/data_warehouse.duckdb

metlano-refresh-catalog:
	cd meltano && rm -rf .meltano/run/* && rm -rf meltano.db

postgres-refresh-data:
	bash ./infra/postgres/refresh_data.sh

postgres-revoke-select-permission:
	bash ./infra/postgres/revoke_select_permission.sh

postgres-revoke-replication-permission:
	bash ./infra/postgres/revoke_replication_permission.sh

tap-ascenda-replicate-data:
	cd ./meltano && meltano run tap-postgres-ascenda target-redshift

tap-default-replicate-data:
	cd ./meltano && meltano run tap-postgres target-redshift

test-transaction-first-record-tap-ascenda:
	bash ./infra/postgres/transaction_first_record.sh
	make tap-ascenda-replicate-data

test-transaction-first-record-tap-default:
	bash ./infra/postgres/transaction_first_record.sh
	make tap-default-replicate-data

test-transaction-second-record-tap-ascenda:
	bash ./infra/postgres/transaction_second_record.sh
	make tap-ascenda-replicate-data

test-transaction-second-record-tap-default:
	bash ./infra/postgres/transaction_second_record.sh
	make tap-default-replicate-data

test-add-column-tap-ascenda:
	bash ./infra/postgres/refresh_data.sh
	make metlano-refresh-catalog
	make tap-ascenda-replicate-data
	bash ./infra/postgres/add_column.sh
	make metlano-refresh-catalog
	make tap-ascenda-replicate-data

test-add-column-tap-default:
	bash ./infra/postgres/refresh_data.sh
	make metlano-refresh-catalog
	make tap-default-replicate-data
	bash ./infra/postgres/add_column.sh
	make metlano-refresh-catalog
	make tap-default-replicate-data

test-delete-column-tap-ascenda:
	bash ./infra/postgres/refresh_data.sh
	bash ./infra/postgres/add_column.sh
	bash ./infra/postgres/delete_column.sh
	make metlano-refresh-catalog
	make tap-ascenda-replicate-data

test-delete-column-tap-default:
	bash ./infra/postgres/refresh_data.sh
	bash ./infra/postgres/add_column.sh
	bash ./infra/postgres/delete_column.sh	
	make metlano-refresh-catalog
	make tap-default-replicate-data

test-update-column-tap-ascenda:
	bash ./infra/postgres/refresh_data.sh
	bash ./infra/postgres/add_column.sh
	bash ./infra/postgres/delete_column.sh
	bash ./infra/postgres/update_column.sh
	make metlano-refresh-catalog
	make tap-ascenda-replicate-data

test-update-column-tap-default:
	bash ./infra/postgres/refresh_data.sh
	bash ./infra/postgres/add_column.sh
	bash ./infra/postgres/delete_column.sh
	bash ./infra/postgres/update_column.sh
	make metlano-refresh-catalog
	make tap-default-replicate-data
