args = $(filter-out $@, $(MAKECMDGOALS))

console:
	./bin/console

server:
	./bin/server

utest:
	./bin/test

db:
	./bin/db

psql:
	./bin/psql

%:
	@:
