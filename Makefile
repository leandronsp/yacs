console:
	docker-compose run dev bash

server:
	docker-compose run \
		--service-ports \
		--use-aliases \
		dev ruby server.rb

utest:
	docker-compose run dev ruby server_test.rb
