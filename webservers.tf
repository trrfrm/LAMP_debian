resource "aws_instance" "WebServer" {
  count                         = local.count
  ami                           = data.aws_ami.latest-ubuntu-image.id
  instance_type                 = local.instance_type
  associate_public_ip_address   = local.public_ip_enabled
  key_name                      = local.key_name 
  subnet_id                     = aws_subnet.subnets[count.index].id
  vpc_security_group_ids        = [aws_security_group.Web-SG.id]

  tags                          = {
      Name                      = local.webserver_tags[count.index]
  }
  depends_on    = [ aws_vpc.vnet, aws_subnet.subnets ]

  connection {
    type        = local.connection_type
    user        = local.username
    private_key = file(local.key_path)
    host        = self.public_ip
  }
  provisioner "file" {
    source      = local.source
    destination = local.destination
  }
  provisioner "remote-exec" {
  inline        = [
    "sudo chmod u+x phpinfo.sh",
    "sh ~/phpinfo.sh"
    ]
  }
}
