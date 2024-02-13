variable "PACKETRUSHER_VERSION" {
  default = "main"
}

variable "UBUNTU_VERSION" {
  default = "focal"
}

variable "GO_VERSION" {
  default = "1.21.3"
}

group "default" {
  targets = ["packetrusher"]
}

target "packetrusher" {
  context = "./images/packetrusher"
  tags = ["packetrusher:${PACKETRUSHER_VERSION}"]
  output = ["type=image"]
}
