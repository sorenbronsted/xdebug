IMAGE := xdebug

up:
	docker-compose up -d

down:
	docker-compose down --remove-orphans

image:
	docker-compose build

logs:
	docker-compose logs -f

bash:
	docker-compose exec $(IMAGE) bash

