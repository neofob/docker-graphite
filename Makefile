# Launching docker graphite makes easy
#
# __author__: tuan t. pham

# a hack to use .env file for docker-compose
include .env

all: docker

docker:
	@echo "Building docker image"
	docker-compose build

help:
	@echo	"A simple Makefile to shortcut of docker-compose commands."
	@echo	"Edit .env file to customize environment variables"
	@echo	"\033[1;31mAvailable targets:\033[0m"
	@echo
	@echo	"\033[1;31mhelp:\033[0m"
	@echo	"\tThis help message"
	@echo
	@echo	"\033[1;31mdocker:\033[0m"
	@echo	"\tBuild the docker from Dockerfile and tag it as $(DOCKER_NAME):$(TAG)"
	@echo
	@echo	"\033[1;31mrun:\033[0m"
	@echo	"\tRun docker $(DOCKER_NAME):$(TAG) as $(CONTAINER_NAME)"
	@echo	"\tmake run"
	@echo
	@echo	"\033[1;31mdump:\033[0m"
	@echo	"\tDump environment variables"
	@echo
	@echo	"\033[1;31mpull:\033[0m"
	@echo	"\tPull docker $(DOCKER_NAME):$(TAG)"
	@echo
	@echo	"\033[1;31mshutdown:\033[0m"
	@echo	"\tStop and remove container $(CONTAINER_NAME)"
	@echo
	@echo	"\033[1;31mstop:\033[0m"
	@echo	"\tStop container $(CONTAINER_NAME)"
	@echo
	@echo	"\033[1;31mstart:\033[0m"
	@echo	"\tStart container $(CONTAINER_NAME)"
	@echo
	@echo	"\033[1;31mclean:\033[0m"
	@echo	"\tRemove the docker image $(DOCKER_NAME):$(TAG)"
	@echo
	@echo	"__author__: tuan t. pham"

dump:
	@echo "DOCKER_NAME=$(DOCKER_NAME)"
	@echo "TAG=$(TAG)"
	@echo "NAME=$(CONTAINER_NAME)"
	@echo "GRAPHITE_STORAGE=$(GRAPHITE_STORAGE)"
	@echo "LOG_DIR=$(LOG_DIR)"
	@echo "CONTAINER_HOSTNAME=$(CONTAINER_HOSTNAME)"
	@echo "CONFIG_DIR=$(CONFIG_DIR)"

pull:
	@docker pull $(DOCKER_NAME):$(TAG)

run:
	@mkdir -p $(GRAPHITE_STORAGE)/log
	@echo "Starting docker $(CONTAINER_NAME)"
	@docker-compose up -d

	@docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(CONTAINER_NAME)

shutdown:
	docker-compose down

stop:
	docker-compose stop

start:
	docker-compose start

clean:
	@echo "Removing the old docker image $(DOCKER_NAME):$(TAG)"
	docker rmi -f $(DOCKER_NAME):$(TAG)
