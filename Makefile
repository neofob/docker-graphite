# Launching docker graphite makes easy
#
# __author__: tuan t. pham

DOCKER_NAME ?=neofob/graphite
TAG ?=0.1.5-rc2
NAME ?=graphite

# hostname to set inside the container
CONTAINER_HOSTNAME ?=$(shell hostname)-docker
GRAPHITE_STORAGE ?=$(shell pwd)/graphite_storage
LOG_DIR ?=$(GRAPHITE_STORAGE)/log
CONFIG_DIR ?=$(shell pwd)/conf
HOSTNAME=$(shell hostname)

all: docker

docker:
	@echo "Building docker image $(DOCKER_NAME):$(TAG)"
	DOCKER_NAME=$(DOCKER_NAME) TAG=$(TAG)	 \
	CONTAINER_HOSTNAME=$(CONTAINER_HOSTNAME) \
	NAME=$(NAME) \
	HOSTNAME=$(HOSTNAME) \
	docker-compose build

help:
	@echo	"\033[1;31mAvailable targets:\033[0m"
	@echo
	@echo	"\033[1;31mhelp:\033[0m"
	@echo	"\tThis help message"
	@echo
	@echo	"\033[1;31mdocker:\033[0m"
	@echo	"\tBuild the docker from Dockerfile and tag it as $(DOCKER_NAME):$(TAG)"
	@echo	"\tCustomize the tag DOCKER_NAME=MyName TAG=MyTag make docker"
	@echo
	@echo	"\033[1;31mrun:\033[0m"
	@echo	"\tRun docker $(DOCKER_NAME):$(TAG) as $(NAME)"
	@echo	"\tWHISPER_DATA=$(WHISPER_DATA)" LOG_DIR=$(LOG_DIR) make run
	@echo	"\tUse absolute path"
	@echo
	@echo	"\033[1;31mdump:\033[0m"
	@echo	"\tDump environment variables"
	@echo
	@echo	"\033[1;31mpull:\033[0m"
	@echo	"\tPull docker $(DOCKER_NAME):$(TAG)"
	@echo
	@echo	"\033[1;31mshutdown:\033[0m"
	@echo	"\tStop and remove container $(NAME)"
	@echo
	@echo	"\033[1;31mstop:\033[0m"
	@echo	"\tStop container $(NAME)"
	@echo
	@echo	"\033[1;31mstart:\033[0m"
	@echo	"\tStart container $(NAME)"
	@echo
	@echo	"\033[1;31mclean:\033[0m"
	@echo	"\tRemove the docker image $(DOCKER_NAME):$(TAG)"
	@echo
	@echo	"__author__: tuan t. pham"

dump:
	@echo "DOCKER_NAME=$(DOCKER_NAME)"
	@echo "TAG=$(TAG)"
	@echo "NAME=$(NAME)"
	@echo "GRAPHITE_STORAGE=$(GRAPHITE_STORAGE)"
	@echo "LOG_DIR=$(LOG_DIR)"
	@echo "CONTAINER_HOSTNAME=$(CONTAINER_HOSTNAME)"
	@echo "CONFIG_DIR=$(CONFIG_DIR)"

pull:
	@docker pull $(DOCKER_NAME):$(TAG)

run:
	@mkdir -p $(GRAPHITE_STORAGE)/log
	@echo "Starting docker $(NAME)"
	@echo "$(DOCKER_NAME):$(TAG)"
	@echo "LOG_DIR=$(LOG_DIR)"

	@GRAPHITE_STORAGE=$(GRAPHITE_STORAGE) LOG_DIR=$(LOG_DIR) \
		DOCKER_NAME=$(DOCKER_NAME) TAG=$(TAG)	 \
		CONTAINER_HOSTNAME=$(CONTAINER_HOSTNAME) \
		CONFIG_DIR=$(CONFIG_DIR)		 \
		NAME=$(NAME) \
		HOSTNAME=$(HOSTNAME) \
		docker-compose up -d

	@docker inspect --format '{{ .NetworkSettings.IPAddress }}' $(NAME)

shutdown:
	docker-compose down

stop:
	docker-compose stop

start:
	docker-compose start

clean:
	@echo "Removing the old docker image $(DOCKER_NAME):$(TAG)"
	docker rmi -f $(DOCKER_NAME):$(TAG)
