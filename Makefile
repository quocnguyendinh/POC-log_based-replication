infra-up:
	docker-compose -f ./infra/docker-compose.yml up -d

infra-down:
	docker-compose -f ./infra/docker-compose.yml down

infra-restart:
	docker-compose -f ./infra/docker-compose.yml restart