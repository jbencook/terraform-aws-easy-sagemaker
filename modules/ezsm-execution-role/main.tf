# Add SageMaker FullAccess to all execution roles
resource "aws_iam_role_policy_attachment" "sagemaker" {
  role       = aws_iam_role.execution_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

resource "aws_iam_role_policy_attachment" "additional_policy_arns" {
  for_each = var.policy_arns

  role       = aws_iam_role.execution_role.id
  policy_arn = each.key
}

resource "aws_iam_role_policy" "inline_policies" {
  for_each = var.inline_policies

  name   = trimsuffix(basename(each.key), ".json")
  role   = aws_iam_role.execution_role.id
  policy = file(each.key)
}

locals {
  policy_arns_string = join(",", var.policy_arns)
  policies_string    = join(",", [for path in var.inline_policies : file(path)])
}

resource "random_id" "policies" {
  keepers = {
    policies = join(",", [local.policy_arns_string, local.policies_string])
  }
  byte_length = 4
}

resource "aws_iam_role" "execution_role" {
  name = "AmazonSageMaker-execution-role-${random_id.policies.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      },
    ]
  })
}
