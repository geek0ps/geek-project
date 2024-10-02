terraform {
  source = "../../../terraform/task-3"
}

locals {
      my_env_conf = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
      my_region   = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.my_region
      common_tags = local.my_env_conf.inputs.common_tags
}

inputs = {
    prefix = "project-a"
}
