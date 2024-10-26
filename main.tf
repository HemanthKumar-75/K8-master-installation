resource "aws_instance" "k8-master-expense" {
  ami           = data.aws_ami.ami_id.id
  instance_type = var.instance_type
  vpc_security_group_ids = [ "sg-048a7cda150b9e388" ]
  root_block_device {
    volume_size = 50
  }
  tags = merge(
    var.tags,
  {
    Name = "K8-master-expense"
  }
  )
}


resource "null_resource" "k8" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = aws_instance.k8-master-expense.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host     = aws_instance.k8-master-expense.public_ip
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    timeout = "5m"
  }

  provisioner "file" {
    source      = "scripts.sh"
    destination = "/tmp/scripts.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/scripts.sh",
      "sudo sh /tmp/scripts.sh"
    ]
  }

}