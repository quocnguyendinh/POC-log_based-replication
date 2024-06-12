infra-up:
	docker-compose -f ./infra/docker-compose.yml up -d

infra-down:
	docker-compose -f ./infra/docker-compose.yml stop

infra-init: infra-up
	cd infra && bash ./duck-db-setup.sh
	cd meltano && poetry run meltano install
	bash ./infra/setup.sh 

infra-shutdown:
	find infra -type f -name "*duckdb*" -delete
	cd meltano && rm -rf .meltano/meltano.db
	docker-compose -f ./infra/docker-compose.yml down

infra-restart:
	docker-compose -f ./infra/docker-compose.yml restart

connect-source-db:
	docker exec -it log_based_postgres psql -U "meltano" -d "meltano"

connect-data-warehouse:
	docker exec -it clickhouse clickhouse-client -u meltano --password meltano --database meltano