#!/bin/bash

# PacketRusher entrypoint

# source helper functions
source "/PacketRusher/helper_functions.sh"

docker_cmd="${@}"

if [[ "${USE_FQDNS}" == TRUE ]]; then
    # ${@} contains the CMD provided by Docker
    # setup config file provided in Docker CMD
    #substitute_fqdns ${@}
    docker_cmd="$(substitute_fqdns ${@})"
fi

# container entrypoint receiving arguments from Docker CMD
/PacketRusher/packetrusher ${docker_cmd}
