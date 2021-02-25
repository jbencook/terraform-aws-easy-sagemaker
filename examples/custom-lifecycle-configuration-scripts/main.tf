module "default_execution_role" {
  source  = "jbencook/easy-sagemaker/aws//modules/execution-role"
  version = "0.0.2"
}

module "custom_scripts_and_ttl" {
  source  = "jbencook/easy-sagemaker/aws//modules/lifecycle-configuration"
  version = "0.0.2"

  time_to_live = {
    duration = "10 minutes"
  }

  on_create = [
    "${path.module}/scripts/hello-world-on-create.sh",
  ]

  on_start = [
    "time_to_live",
    "${path.module}/scripts/install-omegaconf-on-start.sh",
  ]
}

resource "aws_sagemaker_notebook_instance" "instance" {
  name                  = "ezsm-example-custom-lifecycle-configuration-scripts"
  role_arn              = module.default_execution_role.arn
  instance_type         = "ml.t2.medium"
  lifecycle_config_name = module.custom_scripts_and_ttl.name
}
