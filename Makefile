CONTAINER ?= sl-app

.PHONY: shell up down rebuild

# Open a bash shell in the PHP app container to run artisan/composer commands
shell:
	docker exec -it $(CONTAINER) bash

# Start all containers in the background
up:
	docker-compose up -d

# Stop and remove the containers
down:
	docker-compose down

# Rebuild images from scratch and restart the containers
rebuild:
	docker-compose down
	docker-compose build --no-cache
	docker-compose up -d
