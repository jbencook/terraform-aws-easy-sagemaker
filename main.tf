module "default_execution_role" {
  source = "./modules/execution-role"

  # If you want to run the root example outside of this repo:
  # source  = "jbencook/easy-sagemaker/aws//modules/execution-role"
  # version = "0.0.2"
}

module "sagemaker_examples_repo" {
  source = "./modules/code-repository"

  # If you want to run the root example outside of this repo:
  # source  = "jbencook/easy-sagemaker/aws//modules/code-repository"
  # version = "0.0.2"

  repository_url = "https://github.com/aws/amazon-sagemaker-examples.git"
}

module "ngrok_and_ttl_on_start" {
  source = "./modules/lifecycle-configuration"

  # If you want to run the root example outside of this repo:
  # source  = "jbencook/easy-sagemaker/aws//modules/lifecycle-configuration"
  # version = "0.0.2"

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
