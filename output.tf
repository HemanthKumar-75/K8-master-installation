output "master-public-ip" {
  description = "Public IP of K8 master instance"
  value = aws_instance.k8-master-expense.public_ip
}