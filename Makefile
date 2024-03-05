DC := docker-compose -f ./srcs/docker-compose.yml

all:
	# @mkdir -p /home/data/wordpress
	# @mkdir -p /home/data/mysql
	@$(DC) up -d --build

down:
	@$(DC) down

re: clean all

clean:
	@$(DC) down -v --remove-orphans     # Down stops containers and removes connected volumes
	@docker rmi -f $$(docker images -q) # Deletes unused images

.PHONY: all down re clean
