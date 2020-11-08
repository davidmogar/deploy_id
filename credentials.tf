resource "aws_key_pair" "deploy_it" {
  key_name   = "deploy_it"
  public_key = file(var.ssh_public_key_path)
}
