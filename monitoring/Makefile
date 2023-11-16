.DEFAULT_GOAL := help
DOCKER_ENV := .env
USER_NAME := $(shell awk -F'=' '/USERNAME/ { print $$2 }' ${DOCKER_ENV})
THIS_FILE := $(lastword $(MAKEFILE_LIST))
export USER_NAME
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'

###########################################################################################
#                              docker build & push
###########################################################################################

.PHONY: env
env:
	eval $$(export USER_NAME=${USER_NAME})
	@echo ${USER_NAME}

.PHONY: docker-login
docker-login:
	docker login -u ${USER_NAME}

.PHONY: build-all
build-all: env build-ui build-comment build-post build-prometheus build-blackbox

.PHONY: build-ui
build-ui: env ./src/ui/docker_build.sh ./src/ui/*
	cd ./src/ui && bash docker_build.sh && cd -

.PHONY: build-comment
build-comment: env ./src/comment/docker_build.sh ./src/comment/*
	cd ./src/comment && bash docker_build.sh && cd -

.PHONY: build-post
build-post: env ./src/post-py/docker_build.sh ./src/post-py/*
	cd ./src/post-py && bash docker_build.sh && cd -

.PHONY: build-blackbox
build-blackbox: env ./monitoring/blackbox-exporter/*
	docker build -t $$USER_NAME/blackbox-exporter ./monitoring/blackbox-exporter/

.PHONY: build-prometheus
build-prometheus: env ./monitoring/prometheus/*
	docker build -t $$USER_NAME/prometheus ./monitoring/prometheus/

.PHONY: push-all
push-all: env push-ui push-comment push-post push-prometheus push-blackbox

.PHONY: push-ui
push-ui: docker-login
	docker push $$USER_NAME/ui

.PHONY: push-comment
push-comment: docker-login
	docker push $$USER_NAME/comment

.PHONY: push-post
push-post: docker-login
	docker push $$USER_NAME/post

.PHONY: push-prometheus
push-prometheus: docker-login
	docker push $$USER_NAME/prometheus

.PHONY: push-blackbox
push-blackbox: docker-login
	docker push $$USER_NAME/blackbox-exporter
