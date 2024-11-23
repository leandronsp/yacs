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

build.production.app: ## Build the app image for production
	@docker build -t leandronsp/yacs --target production .

build.production.db: ## Build the database image for production
	@docker build -f db.Dockerfile -t leandronsp/yacs-db .

push.production.app: ## Push the app production image
	@docker push leandronsp/yacs:${version}

push.production.db: ## Push the database production image
	@docker push leandronsp/yacs-db:${version}

run.production.db: ## Run the database in production mode
	@docker run \
		--rm \
		--network yacs-production \
		--name yacs-production-db \
		-e POSTGRES_USER=${db_user} \
		-e POSTGRES_PASSWORD=${db_password} \
		-e POSTGRES_DB=${db_name} \
		-v yacs_production_data:/var/lib/postgresql/data \
		leandronsp/yacs-db:${version}

populate.production.db: ## Populate the production database
	@docker exec \
		-it \
		yacs-production-db \
		bash -c "cat /db/init.sql | psql -U ${db_user} ${db_name}"
	@docker exec \
		-it \
		yacs-production-db \
		bash -c "cat /db/populate.sql | psql -U ${db_user} ${db_name}"

run.production.app: ## Run the app in production mode
	@docker run \
		-it \
		--rm \
		--network yacs-production \
		--name yacs-production-app \
		-p 5000:4000 \
		-e APP_ENV=production \
		-e DB_HOST=${db_host} \
		-e DB_USER=${db_user} \
		-e DB_PASSWORD=${db_password} \
		-e DB_NAME=${db_name} \
		leandronsp/yacs:${version}

export ANSIBLE_INVENTORY := ansible/inventory.ini

define ansible_playbook
    ansible-playbook --extra-vars "@ansible/vars.yml" $(1)
endef

ansible.setup: ## Setup Docker & NGINX in production
	@$(call ansible_playbook, ansible/configure-docker.yml)
	@$(call ansible_playbook, ansible/configure-nginx.yml)

ansible.setup.db: ## Setup & Populate the database in production
	@$(call ansible_playbook, ansible/configure-db.yml -e "version=latest")

ansible.deploy: ## Deploy the application in production at a specific version (version=)
	@$(call ansible_playbook, ansible/deploy-app.yml -e "version=${version}")
