# Example: private code repositories

You can easily add private code repositories to your notebook instances: simply add an `auth` configuration object to the `code-repository` module:

```hcl
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
```

If you add a `./variables.tf`, you can specify that the `password` parameter is sensitive:

```hcl
variable "github_token" {
  type        = string
  sensitive   = true
  description = "Your GitHub token with repo access (or password)"
}
```

This prevents Terraform from printing the value in apply previews. If you don't pass in a `secrets.tfvars` (as in the [root example](https://github.com/jbencook/terraform-aws-easy-sagemaker)), Terraform will ask you to input the password when you run `terraform apply`.