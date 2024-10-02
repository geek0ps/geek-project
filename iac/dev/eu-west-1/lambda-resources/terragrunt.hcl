terraform {
  source = "../../../terraform/task-4"
}

locals {
      my_env_conf = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
      my_region   = read_terragrunt_config(find_in_parent_folders("region.hcl")).locals.my_region
      common_tags = local.my_env_conf.inputs.common_tags
}

dependency "s3" {
  config_path = "../bucket-iam-resources"
  mock_outputs = {
    role_name = "eksksns"
    bucket_id = "94o4jhdnmsu"
    bucket_arn = "arn:aws:s3::839374765493:test"
    role_arn = "arn:aws:iam::839374765493:user/test"
  }
}

inputs = {
    role_name = dependency.s3.outputs.role_name
    bucket_id = dependency.s3.outputs.bucket_id
    bucket_arn = dependency.s3.outputs.bucket_arn
    role_arn = dependency.s3.outputs.role_arn
}
