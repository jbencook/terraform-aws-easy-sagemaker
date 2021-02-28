module "default_execution_role" {
  source  = "jbencook/easy-sagemaker/aws//modules/execution-role"
  version = "0.0.2"
}

module "gitaffe_pose_repo" {
  source  = "jbencook/easy-sagemaker/aws//modules/code-repository"
  version = "0.0.2"

  # Add a private repository URL
  repository_url = "https://github.com/jbencook/giraffe-pose.git"

  # Use your own GitHub username
  auth = {
    username = "jbencook"
    password = var.github_token
  }
}

resource "aws_sagemaker_notebook_instance" "instance" {
  name                    = "ezsm-private-repos"
  role_arn                = module.default_execution_role.arn
  instance_type           = "ml.t2.medium"
  default_code_repository = module.gitaffe_pose_repo.name
}
