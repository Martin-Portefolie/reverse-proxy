# Makefile for managing Docker Compose environments

# Define variables for network and environment files
NETWORK_NAME=traefik-net
ENV_FILE=.env
DOCKER_COMPOSE=docker-compose.yml

# Create the Docker network if it doesn't exist
.PHONY: create-network
create-network:
	@docker network ls | grep -w $(NETWORK_NAME) > /dev/null || docker network create $(NETWORK_NAME)
	@echo "Network $(NETWORK_NAME) is ready."

# Start the local environment
.PHONY: start-local
start-local: create-network
	@docker-compose -f $(DOCKER_COMPOSE) -f docker-compose.local.yml --env-file $(ENV_FILE) up -d
	@echo "Local environment started."

# Start the server environment
.PHONY: start-server
start-server: create-network
	@docker-compose -f $(DOCKER_COMPOSE) -f docker-compose.server.yml --env-file $(ENV_FILE) up -d
	@echo "Server environment started."

# Stop all running containers
.PHONY: stop
stop:
	@docker-compose -f $(DOCKER_COMPOSE) down
	@echo "All containers stopped."

# Clean up (remove containers, networks, and volumes)
.PHONY: clean
clean:
	@docker-compose -f $(DOCKER_COMPOSE) down -v
	@docker network rm $(NETWORK_NAME)
	@echo "Cleaned up all containers, networks, and volumes."

