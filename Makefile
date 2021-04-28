console:
	docker-compose run dev bash

utest:
	docker-compose run dev ruby server_test.rb
