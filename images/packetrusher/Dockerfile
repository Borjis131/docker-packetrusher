# syntax=docker/dockerfile:1

# global build-time arguments for FROM statements
# (https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact)

ARG UBUNTU_VERSION="focal"

FROM ubuntu:${UBUNTU_VERSION} AS builder

# target container architecture
ARG TARGETARCH

# build-time arguments for builder
# currently there is no PacketRusher versioning
ARG PACKETRUSHER_VERSION="main"
ARG DEBIAN_FRONTEND="noninteractive"
ARG GO_VERSION="1.21.3"

# install dependencies
RUN apt-get update && apt-get install make git wget tar -y

# install go version from GO_VERSION
RUN wget https://go.dev/dl/go${GO_VERSION}.linux-${TARGETARCH}.tar.gz && tar -C /usr/local -xzf go${GO_VERSION}.linux-${TARGETARCH}.tar.gz

# Note: The kernel modules needed such as free5gc's gtp5g kernel module must be present on the host

# add go binary to the executable PATH variable
ENV PATH=$PATH:/usr/local/go/bin

# clone PacketRusher and install it
RUN git clone --depth 1 --branch=${PACKETRUSHER_VERSION} https://github.com/HewlettPackard/PacketRusher.git \
	&& cd PacketRusher && go mod download && go build cmd/packetrusher.go

FROM ubuntu:${UBUNTU_VERSION}

# target container architecture
ARG TARGETARCH

# build-time arguments
ARG DEBIAN_FRONTEND="noninteractive"
ARG YQ_VERSION="v4.30.6"

# change working directory
WORKDIR /PacketRusher

# copy executable, default config and libs
COPY --from=builder /PacketRusher/packetrusher /PacketRusher/packetrusher
COPY --from=builder /PacketRusher/config/config.yml /PacketRusher/config/config.yml
COPY --from=builder /usr/local/go /usr/local/go

# install dependencies
RUN apt-get update && apt-get install wget dnsutils iproute2 iperf3 iputils-ping curl -y

# install yq
RUN wget --quiet https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_${TARGETARCH} -O /usr/bin/yq && chmod +x /usr/bin/yq

# add go binary to the executable PATH variable
ENV PATH=$PATH:/usr/local/go/bin

ENTRYPOINT [ "/PacketRusher/packetrusher" ]

# use CMD to provide arguments to ENTRYPOINT (can be overridden by user)
CMD [ "--config /PacketRusher/config/config.yml ue" ]
