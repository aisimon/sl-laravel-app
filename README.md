## What is this

A blank LEMP docker template with the following to start off your work quick

- PHP 8.2.20 (with pdo_mysql zip exif pcntl GD)
- Laravel v11.14
- Mysql 5.7.22
- Nginx:alpine

## What to do with this

1. Clone this repo
2. Check the `.env` file and change the `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD` to your liking
3. Run `docker run --rm -v $(pwd):/app composer install` to install the laravel dependencies. This will create a `vendor` folder in the root directory, and create a `composer.lock` file. There will be docker container created too.
4. Run `docker-compose up -d` to start the containers

Visit `http://localhost:8085` to see the Laravel welcome page.

Use MySQL Workbench connect to the database in port `3306` with the credentials you set in the `.env` file.