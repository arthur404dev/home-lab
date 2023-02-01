.PHONY: help
help:
	@echo "Available commands:"
	@grep '^#.*' $(MAKEFILE_LIST) | sed 's/^#[ \t]*//' | awk '{printf "  %-20s - %s\n", $$1, substr($$0, index($$0, $$1) + length($$1) + 1)}'
# build services are built once and then tagged, by default as project_service - params: c=container_name
build:
	@echo "building services..."
	@docker-compose -f docker-compose.yml build $(c)
# up builds, (re)creates, starts, and attaches to containers for a service - params: c=container_name
up:
	@echo "turning services up..."
	@docker-compose -f docker-compose.yml up -d $(c)
# up-profile builds, (re)creates, starts, and attaches to containers for an entire profile - params: profile_name
up-profile:
	@echo "turning services from profile up..."
	@docker-compose -f docker-compose.yml up -d --profile=$(word 2,$(MAKECMDGOALS))
# start starts existing containers for a service - params: c=container_name
start:
	@echo "starting services..."
	@docker-compose -f docker-compose.yml start $(c) 
# down stops containers and removes containers, networks, and images created by up - params: c=container_name
down:
	@echo "turning services down..."
	@docker-compose -f docker-compose.yml down $(c) 
# down-profile stops containers and removes containers, networks, and images created by up for an entire profile - params: profile_name
down-profile:
	@echo "turning services from profile down..."
	@docker-compose -f docker-compose.yml down --profile=$(word 2,$(MAKECMDGOALS)) $(c) 
# destroy stops containers and removes containers, networks, volumes, and images created by up - params: c=container_name
destroy:
	@echo "destroying containers..."
	@docker-compose -f docker-compose.yml down -v $(c) 
# stop stops running containers without removing them. They can be started again with start - params: c=container_name
stop:
	@echo "stopping services..."
	@docker-compose -f docker-compose.yml stop $(c) 
# restart stops running containers and then rebuild them turning them up forcing recreation and removing orphans - params: c=container_name
restart:
	@echo "restarting services..."
	@docker-compose -f docker-compose.yml stop $(c)
	@docker-compose -f docker-compose.yml up -d --force-recreate --remove-orphans$(c)
# logs display log output from services - params: c=container_name
logs:
	@echo "printing logs..."
	@docker-compose -f docker-compose.yml logs --tail=100 -f $(c)
# ps builds entire environment
ps:
	@docker-compose -f docker-compose.yml ps