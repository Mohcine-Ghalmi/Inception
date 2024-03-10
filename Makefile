DC := docker-compose -f ./srcs/docker-compose.yml

all:
	@sudo mkdir -p /home/mghalmi/data/wordpress
	@sudo mkdir -p /home/mghalmi/data/mysql
	@$(DC) up -d --build

down:
	@$(DC) down

re: clean all

clean:
	@$(DC) down -v --remove-orphans     # Down stops containers and removes connected volumes
	@docker system prune -af --volumes
	@docker rmi -f $$(docker images -q) # Deletes unused images
	@sudo rm -rf /home/mghalmi/data/mysql
	@sudo rm -rf /home/mghalmi/data/wordpress

.PHONY: all down re clean

