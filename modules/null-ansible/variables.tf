variable "extra_arguments" {
  description = "Extra arguments to pass to ansible-playbook"
}

variable "host" {
  description = "Public IP of the remote host"
}

variable "playbook" {
  description = "Path to the playbook file"
}

variable "ssh_key_path" {
  description = "Path to the ssh key to use during the connection"
}

variable "ssh_user" {
  description = "User name to use to connect to the remote host"
}
