resource "null_resource" "inventory" {
  provisioner "local-exec" {
    command = "echo '[all:vars]' > hosts"
  }

  provisioner "local-exec" {
    command = "echo ansible_user=${var.ssh_user} >> hosts"
  }

  provisioner "local-exec" {
    command = "echo ansible_ssh_private_key_file=${var.ssh_key_path} >> hosts"
  }

  provisioner "local-exec" {
    command = "echo '[all]' >> hosts"
  }

  provisioner "local-exec" {
    command = "echo ${var.host} >> hosts"
  }
}

resource "null_resource" "provisioner" {
  depends_on = [null_resource.inventory]

  provisioner "remote-exec" {
    connection {
      host        = var.host
      private_key = file(var.ssh_key_path)
      type        = "ssh"
      user        = var.ssh_user
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i hosts ${join(" ", compact(var.extra_arguments))} ${var.playbook}"
  }

  provisioner "local-exec" {
    command = "rm -f hosts"
  }
}
