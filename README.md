# Yacs

Yet another City search.

```
__   __ _    ____ ____  
\ \ / // \  / ___/ ___| 
 \ V // _ \| |   \___ \ 
  | |/ ___ \ |___ ___) |
  |_/_/   \_\____|____/

```

A simple application for searching cities and related data from around the world, powered by [geonames.org](https://geonames.org/) and [PostgreSQL full-text search](https://www.postgresql.org/docs/current/textsearch.html) capabilities.

- Fast and reliable city search functionality using PostgreSQL, across +12M cities from around the world
- Easy to set up and run locally

### Made with

- ❤️
- [PostgreSQL full-text search](https://www.postgresql.org/docs/current/textsearch.html)
- A dead simple HTTP server written in Ruby, [leandronsp/adelnor](https://github.com/leandronsp/adelnor)
- A very dead simple web framework written in Ruby, [leandronsp/chespirito](https://github.com/leandronsp/chespirito)

### Requirements

Docker. You only need Docker. Seriously.

## Setup

```bash
$ make bundle.install  # Install app dependencies
$ make up              # Start the database and application
$ make db.populate     # Populate the database using data from geonames.org
```

Server is running at http://localhost:4000

### Running in production mode (before deploy)

```bash
$ docker network create yacs-production

$ make build.production.db
$ make run.production.db version=latest db_user=yacs db_password=yacs db_name=yacs
$ make populate.production.db db_user=yacs db_name=yacs

$ make build.production.app
$ make run.production.app version=latest db_host=yacs-production-db db_user=yacs db_password=yacs db_name=yacs
```

Server in production mode is running at http://localhost:5000

## Provisioning & Deploy

First things first, you need to copy the ansible vars example:

```bash
$ cp ansible/vars.yml.example ansible/vars.yml
```

Change the placeholder values, then:

```bash
$ make ansible.setup
$ make ansible.setup.db
$ make ansible.deploy version=latest
```

## Help

`make help`:

```
Usage: make <target>
  help                       Prints available commands
  bundle.install             Install app dependencies
  up                         Start the database and application
  logs                       Follow logs
  psql                       Open psql
  db.populate                Populate data from geonames.org
  db.reset                   Reset database
  build.production.app       Build the app image for production
  build.production.db        Build the database image for production
  push.production.app        Push the app production image
  push.production.db         Push the database production image
  run.production.db          Run the database in production mode
  populate.production.db     Populate the production database
  run.production.app         Run the app in production mode
  ansible.setup              Setup Docker & NGINX in production
  ansible.setup.db           Setup & Populate the database in production
  ansible.deploy             Deploy the application in production at a specific version (version=)
```

----

[ASCII art generator](http://www.network-science.de/ascii/)
