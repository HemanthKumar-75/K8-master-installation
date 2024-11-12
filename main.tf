resource "aws_instance" "k8-master-expense" {
  ami                    = data.aws_ami.ami_id.id
  instance_type          = var.instance_type
  vpc_security_group_ids = ["sg-048a7cda150b9e388"]
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
  depends_on = [ null_resource.aws_config ]
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
    timeout  = "15m"
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

resource "null_resource" "aws_config" {
  provisioner "local-exec" {
  command = <<EOT
      mkdir -p ~/.aws

      # Create credentials file
      echo "[default]" > ~/.aws/credentials
      echo "aws_access_key_id = ${local.aws_access_key_id}" >> ~/.aws/credentials
      echo "aws_secret_access_key = ${local.aws_secret_access_key}" >> ~/.aws/credentials

      # Create config file
      echo "[default]" > ~/.aws/config
      echo "region = ${local.aws_region}" >> ~/.aws/config

      # Set secure permissions on the AWS credentials and config files
      chmod 600 ~/.aws/credentials
      chmod 600 ~/.aws/config
    EOT
  }
}