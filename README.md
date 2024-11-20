# Yacs

Yet another City search.

A simple application for searching cities and related data from around the world, powered by [geonames.org](https://geonames.org/) and PostgreSQL full-text search capabilities.

```
__   __ _    ____ ____  
\ \ / // \  / ___/ ___| 
 \ V // _ \| |   \___ \ 
  | |/ ___ \ |___ ___) |
  |_/_/   \_\____|____/

```

- Fast and reliable city search functionality using PostgreSQL, across +12M cities from around the world
- Easy to set up and run locally

### Requirements

Docker.

### Setup

```bash
$ make bundle.install  # Install app dependencies
$ make up              # Start the database and application
$ make db.populate     # Populate the database using data from geonames.org
```

Server is running at http://localhost:4000

### Help

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
```

----

[ASCII art generator](http://www.network-science.de/ascii/)
