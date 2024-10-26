
variable "tags" {
  type = map
  default = {
    envinronment = "dev"
    project = "expense"
    resource = "for k8"
    Created_by = "HemanthKumar"
    terraform = true
  }
}

variable "instance_type" {
  # default = "t2.micro"
}