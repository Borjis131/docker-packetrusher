# include docker-compose .env file
include .env

.PHONY: build-packetrusher

build-packetrusher:
	docker build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg PACKETRUSHER_VERSION=${PACKETRUSHER_VERSION} --build-arg GO_VERSION=${GO_VERSION} -t packetrusher:${PACKETRUSHER_VERSION} ./images/packetrusher
