locals {
  my_region = basename(get_terragrunt_dir())
}

generate "aws_provider" {
  path      = "aws_provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.my_region}"
}
  EOF
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket  = "terraform-state"
    key     = "${path_relative_to_include()}/terraform.tfstate"
    region  = "${local.my_region}"
    encrypt = true
  }
}