infra-up:
	docker-compose -f ./infra/docker-compose.yml up -d

infra-down:
	docker-compose -f ./infra/docker-compose.yml stop

infra-init: infra-up
	bash ./infra/setup.sh 

infra-shutdown:
	docker-compose -f ./infra/docker-compose.yml down

infra-restart:
	docker-compose -f ./infra/docker-compose.yml restart

connect-source-db:
	docker exec -it log_based_postgres psql -U "meltano" -d "meltano"

connect-data-warehouse:
	docker exec -it clickhouse clickhouse-client -u meltano --password meltano --database meltano