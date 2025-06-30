.PHONY: test

# MiniTest
test:
	@echo 'Run tests...'
	docker-compose run --rm web bundle exec rake test

# Docker
down:
	docker-compose down

build:
	docker-compose build

up:
	docker-compose up -d