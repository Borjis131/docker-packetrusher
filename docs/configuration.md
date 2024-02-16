# Configuration guide

You can specify FQDNs for `gnodeb controlif` (gNB N2), `gnodeb dataif` (gNB N3) and `amfif ip` (AMF N2) in the configuration file and the entrypoint of this image will parse them.
```yaml
gnodeb:
  controlif:
    ip: gnb.packetrusher.org
    port: 38412
```

Add your custom configuration file to the packetrusher container like:
```yaml
services:
  ...
  packetrusher:
  ...
    configs:
      - source: packetrusher_config
        target: /PacketRusher/config/packetrusher.yaml
...
configs:
  packetrusher_config:
    file: /path/to/file/packetrusher.yaml
```

Specify the command to run by the packetrusher container like:
```yaml
services:
  ...
  packetrusher:
  ...
    command: "--config /PacketRusher/config/packetrusher.yaml ue"
```
