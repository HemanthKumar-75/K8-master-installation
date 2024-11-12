data "aws_ami" "ami_id" {
    
      most_recent = true
    owners = ["973714476881"]

    filter {
        name = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }

    filter {
        name = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}

data "aws_ssm_parameter" "aws_access_key_id" {
  name = "access-key-id"
  with_decryption = true
}

data "aws_ssm_parameter" "aws_secret_access_key" {
  name = "secret_access_key"
  with_decryption = true
}

data "aws_ssm_parameter" "aws_region" {
  name = "region"
}