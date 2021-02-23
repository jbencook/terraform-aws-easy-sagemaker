module "default_execution_role" {
  source = "./modules/ezsm-execution-role"
}

module "sagemaker_examples_repo" {
  source         = "./modules/ezsm-code-repository"
  repository_url = "https://github.com/aws/amazon-sagemaker-examples.git"
}

module "ngrok_and_ttl_on_start" {
  # TODO: add link to registry source
  source = "./modules/ezsm-lifecycle-configuration"

  time_to_live = {
    duration = "10 minutes"
  }

  ngrok_ssh = {
    authtoken   = var.ngrok_authtoken
    public_keys = var.ngrok_public_keys
  }

  on_start = [
    "time_to_live",
    "ngrok_ssh",
  ]
}

resource "aws_sagemaker_notebook_instance" "instance" {
  name                    = "ezsm"
  role_arn                = module.default_execution_role.arn
  instance_type           = "ml.t2.medium"
  default_code_repository = module.sagemaker_examples_repo.name
  lifecycle_config_name   = module.ngrok_and_ttl_on_start.name
}
