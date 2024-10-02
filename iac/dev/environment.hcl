locals {
  my_env = basename(get_terragrunt_dir())
}

inputs = {
  common_tags = {
    Terragrunt  = "true"
    Environment = local.my_env
  }
}