include environment.env

build:
	docker-compose build

up:
	docker-compose up -d

logs:
	docker-compose logs -f backend

console:
	docker-compose exec backend rails console

bash:
	docker-compose exec backend bash

exec-db:
	docker-compose exec db bash

stop:
	docker-compose stop

down:
	docker-compose down
