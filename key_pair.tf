resource "aws_key_pair" "my_own_private_key" {
  key_name   = var.public_key.name
  public_key = file(var.public_key.path)
  tags       = var.tags_for_app
}