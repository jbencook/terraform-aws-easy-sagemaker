# Easy SageMaker Execution Role

This module manages execution roles for SageMaker notebook instances. The `AmazonSageMakerFullAccess` policy is automatically attached to the role. Additionally, you can add new custom inline policies or existing policies from your account.

## Usage

```hcl
module "simple_execution_role" {
  source = "github.com/jbencook/terraform-aws-easy-sagemaker//modules/execution-role"

  policy_arns = [
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
}
```

To add existing policies, simply add the policy ARN string to the `policy_arns` parameter. To add new inline policies, create a folder with a separate JSON file for each policy. Each JSON file needs to be a valid IAM policy.
