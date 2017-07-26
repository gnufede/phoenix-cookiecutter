PHONY: start repl test clean wipe

proj_name := $(shell basename $(PWD))

docker/Dockerfile.bootstrap: docker/Dockerfile.part.base docker/Dockerfile.part.bootstrap
	cat docker/Dockerfile.part.base docker/Dockerfile.part.bootstrap > docker/Dockerfile.bootstrap

env/bootstrap/created: docker/Dockerfile.bootstrap env/bootstrap/docker-compose.yml scripts/docker-bootstrap.sh
	docker-compose -f env/bootstrap/docker-compose.yml build
	docker-compose -f env/bootstrap/docker-compose.yml run -e PROJ_NAME=$(proj_name) bootstrap
	touch env/bootstrap/created

env/bootstrap/config_db: env/bootstrap/created scripts/config_db.sh
	scripts/config_db.sh $(proj_name)
	touch env/bootstrap/config_db

docker/Dockerfile.dev: docker/Dockerfile.part.base docker/Dockerfile.part.dev
	cat docker/Dockerfile.part.base docker/Dockerfile.part.dev > docker/Dockerfile.dev
	sed -i "s/PROJ_NAME/$(proj_name)/ig" docker/Dockerfile.dev

build: docker/Dockerfile.dev env/dev/docker-compose.yml scripts/docker-dev.sh
	docker-compose -f env/dev/docker-compose.yml build
	touch build

start: env/bootstrap/config_db build
	docker-compose -f env/dev/docker-compose.yml up

repl: env/bootstrap/config_db build
	docker-compose -f env/dev/docker-compose.yml run --service-ports webapp iex -S mix phx.server

test: env/bootstrap/config_db build
	docker-compose -f env/dev/docker-compose.yml run --service-ports -e MIX_ENV=test webapp mix test

clean:
	-rm docker/Dockerfile.dev
	-rm build

wipe: clean
	-rm docker/Dockerfile.bootstrap
	-rm env/bootstrap/config_db
	-rm env/bootstrap/config_db
	-rm env/bootstrap/created
	-rm -rf $(proj_name)
