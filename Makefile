SHELL = /bin/bash
.ONESHELL:
.DEFAULT_GOAL: help

help: ## Prints available commands
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[.a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)


bundle.install: ## Install app dependencies
	@docker-compose run app bash -c "bundle"

up: ## Start the database and application
	@docker-compose up -d

logs: ## Follow logs
	@docker-compose logs -f

psql: ## Open psql
	@docker-compose exec db psql -U yacs yacs

db.populate: ## Populate data from geonames.org
	@bin/populate

db.reset: ## Reset database
	@bin/reset
