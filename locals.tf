locals {
  aws_access_key_id = data.aws_ssm_parameter.aws_access_key_id.value
  aws_secret_access_key = data.aws_ssm_parameter.aws_secret_access_key.value
  aws_region = data.aws_ssm_parameter.aws_region.value
}