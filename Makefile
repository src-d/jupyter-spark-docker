PROJECT = jupyter-spark

DOCKER_REGISTRY = docker.io

# Including ci Makefile
CI_REPOSITORY ?= https://github.com/src-d/ci.git
CI_PATH ?= $(shell pwd)/.ci
CI_VERSION = v1
MAKEFILE := $(CI_PATH)/Makefile.main
$(MAKEFILE):
	git clone --quiet --depth 1 --branch $(CI_VERSION) $(CI_REPOSITORY) $(CI_PATH);
-include $(MAKEFILE)

DOCKER_IMAGE = $(DOCKER_REGISTRY)/$(DOCKER_ORG)/$(PROJECT):$(VERSION)

docker-test: docker-build
	docker rm -f $(PROJECT)-test || true
	docker run --name $(PROJECT)-test --rm -p 8888:8888 -d $(DOCKER_IMAGE)
	wget --tries=5 http://localhost:8888


