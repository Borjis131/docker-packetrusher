# PacketRusher in Docker

PacketRusher image ready for Docker.

## Important notes

PacketRusher needs free5gc's gtp5g kernel module. This module should be present on the host running this Docker image.

For free5gc's gtp5g kernel module to work you should use any distro with kernel below 5.15.X. Ubuntu 20.04 is recommended.

Download and install free5gc's gtp5g kernel module in the host and then use this Docker image.

### Pre-built images

Pre-built images available on GitHub's Container Registry using the PacketRusher's project tags

| Image name                                | gtp5g kernel module version |
| ---                                       | ---                         |
| ghcr.io/borjis131/packetrusher:20240521   | v0.8.6                      |
| ghcr.io/borjis131/packetrusher:20250225   | v0.9.3                      |

## Configure it

Check documentation at [docs/configuration](docs/configuration.md)

## Build it (2 ways)

### First way (make + docker compose build)

>Note: Requires make and docker-compose-plugin

To create the packetrusher image run:
```bash
make
```

>Note: This command uses the `.env` file, please update the `PACKETRUSHER_VERSION`, `UBUNTU_VERSION` and `GO_VERSION` variables there before running it.

### Second way (docker buildx bake)

>Note: Requires docker-buildx-plugin

To create the packetrusher image run:
```bash
docker buildx bake
```

>Note: This command uses the `docker-bake.hcl` file, please update the `PACKETRUSHER_VERSION`, `UBUNTU_VERSION` and `GO_VERSION` variables there before running it.
