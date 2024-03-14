# Misc
.DEFAULT_GOAL = help
PHP_DOCKER=docker exec -it php

    # Vos commandes de construction ici

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————

docker-up: ## docker start
	@echo "--> Starting docker services"
	docker compose up -d


docker-down:  ## docker down
	@echo "--> stopping docker services"
	docker compose down

docker-restart:  ## docker restart
	make docker-down
	make docker-up

## —— ES checker ————————————————————————————————————————————————————————————————
ES_PORT ?= $(shell read -p "Port ES used: " esport; stty echo; echo $$esport)

es-check-shard:
	curl localhost:$(ES_PORT)/_cat/shards

es-check-health:
	curl localhost:$(ES_PORT)/_cluster/health?pretty


### --- set up ---- ###
PROJECT_NAME := $(shell read -p "Project name: " prjname; stty echo; echo $$prjname)
USER ?= $(shell read -p "User name: " usr; stty echo; echo $$usr)

me-started:
	@echo "--> Starting docker services"
	make docker-up
	@echo "--> Init new project"
	$(PHP_DOCKER) symfony new $(PROJECT_NAME) --full
	@echo "--> Create new user $(USERNAME)"
	$(PHP_DOCKER) adduser $(USERNAME)
	$(PHP_DOCKER) chown $(USERNAME):$(USERNAME) -R $(PROJECT_NAME)/
