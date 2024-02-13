#!/bin/bash

# Helper functions for PacketRusher entrypoint

# receives the Docker CMD and returns the config file path
# get_config_file_path_from_docker_cmd <docker_cmd>
function get_config_file_path_from_docker_cmd(){
    # parse only the --config option of the Docker CMD
    while [[ "${#}" -gt 0 ]]; do
        key="${1}"
        case "${key}" in
            --config)
            shift
            config_file_path="${1}"
            ;;
        esac
        shift
    done

    # if --config is present grab argument, if not default to /PacketRusher/config/config.yml
    if [[ "${config_file_path}" == "" ]]; then
        # fallback to default path
        config_file_path="/PacketRusher/config/config.yml"
    fi

    printf "${config_file_path}"
}

# receives the Docker CMD and returns the CMD with the new config file path
# rebuild_docker_cmd <docker_cmd> <new_config_file_path>
function rebuild_docker_cmd(){
    old_cmd="${1}"
    new_config_file_path="${2}"

    # rebuild the Docker CMD command with the new_config_file_path
    cmd="$(sed -E "s/--config[[:space:]][[:graph:]]*[[:space:]]/--config ${new_config_file_path} /g" <<< "${old_cmd}")"
    printf -- "${cmd}"
}

# receives the Docker CMD and modifies the config file provided
# substituting the FQDNs for the appropiate IP addresses
# returns the new Docker CMD with the modified file
# substitute_fqdns <docker_cmd>
function substitute_fqdns(){
    docker_cmd="${@}"

    config_file_path="$(get_config_file_path_from_docker_cmd ${@})"

    # get path from packetrusher_config_file_path
    config_path="$(dirname ${config_file_path})"
    new_filename="packetrusher_ip.yaml"

    # copy the file to be writable
    new_config_file_path="${config_path}/${new_filename}"
    cp "${config_file_path}" "${new_config_file_path}"

    # substitute gNB N2 FQDN
    gnb_n2_fqdn="$(yq '.gnodeb.controlif.ip' "${config_file_path}")"
    export gnb_n2_ip="$(dig +short "${gnb_n2_fqdn}" | tail -n1)"
    yq -i '.gnodeb.controlif.ip = env(gnb_n2_ip)' "${new_config_file_path}"
  
    # substitute gNB N3 FQDN
    gnb_n3_fqdn="$(yq '.gnodeb.dataif.ip' "${config_file_path}")"
    export gnb_n3_ip="$(dig +short "${gnb_n3_fqdn}" | tail -n1)"
    yq -i '.gnodeb.dataif.ip = env(gnb_n3_ip)' "${new_config_file_path}"

    # substitute AMF FQDN
    amf_fqdn="$(yq '.amfif.ip' "${config_file_path}")"
    export amf_ip="$(dig +short "${amf_fqdn}" | tail -n1)"
    yq -i '.amfif.ip = env(amf_ip)' "${new_config_file_path}"

    # escape the replace variable for sed
    escaped_new_config_file_path="$(sed -e 's/[\/&]/\\&/g' <<< "${new_config_file_path}")"

    new_docker_cmd="$(rebuild_docker_cmd "${docker_cmd}" "${escaped_new_config_file_path}")"

    printf -- "$new_docker_cmd"
}
