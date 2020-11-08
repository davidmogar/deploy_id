resource "local_file" "inventory" {
  file_permission = "0440"
  filename        = "ansible/inventory"

  content = <<-EOF
[all:vars]
ansible_user=${var.ssh_user}
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
ansible_ssh_private_key_file=${var.ssh_key_path}

[all]
${var.host}
    EOF
}

resource "null_resource" "provisioner" {
  depends_on = [local_file.inventory]

  provisioner "remote-exec" {
    connection {
      host        = var.host
      private_key = file(var.ssh_key_path)
      type        = "ssh"
      user        = var.ssh_user
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory ${join(" ", compact(var.extra_arguments))} ${var.playbook}"
  }
}
