# Easy SageMaker Code Repository

This module manages code repositories for SageMaker notebook instances. It can add both public and private repositories. For private repositories, it's required to pass in a username and password/auth token, which will be stored as a secret in AWS Secrets Manager.

## Usage

```hcl
module "simple_code_repository" {
  source = "github.com/jbencook/terraform-aws-easy-sagemaker//modules/ezsm-code-repository"

  repository_url = "https://github.com/jbencook/giraffe-pose.git"
  auth = {
    username = "jbencook"
    password = var.github_auth_token
  }
}
```

By default, the name of the code repository will be the name of the repository. You can override this behavior by passing in a `name` parameter. Additionally, you can skip the `auth` parameter for public repositories.
