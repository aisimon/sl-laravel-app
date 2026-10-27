CONTAINER ?= sl-app
DB_CONTAINER ?= sl-db

.PHONY: shell up down rebuild setup

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

# First-time setup: start containers, install dependencies, create .env, migrate
setup: up
	@test -f composer.lock || cp composer.lock_copy composer.lock
	docker exec $(CONTAINER) composer install --no-interaction
	@test -f .env || ( cp .env.example .env && sed -i.bak \
		-e 's/^DB_CONNECTION=sqlite/DB_CONNECTION=mysql/' \
		-e 's/^# DB_HOST=127.0.0.1/DB_HOST=db/' \
		-e 's/^# DB_PORT=3306/DB_PORT=3306/' \
		-e 's/^# DB_DATABASE=laravel/DB_DATABASE=laravel/' \
		-e 's/^# DB_USERNAME=root/DB_USERNAME=root/' \
		-e 's/^# DB_PASSWORD=$$/DB_PASSWORD=pass/' .env && rm .env.bak )
	@grep -qE '^APP_KEY=.+' .env || docker exec $(CONTAINER) php artisan key:generate
	@echo "Waiting for database..."
	@until docker exec $(DB_CONTAINER) mysqladmin ping -h localhost -uroot -ppass --silent 2>/dev/null; do sleep 2; done
	docker exec $(CONTAINER) php artisan migrate --force
