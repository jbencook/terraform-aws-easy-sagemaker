locals {
  repo_name = var.name != null ? var.name : trimsuffix(basename(var.repository_url), ".git")
}

resource "random_id" "secret" {
  keepers = {
    secret = jsonencode(var.auth)
  }
  byte_length = 4
}

resource "aws_secretsmanager_secret" "secret" {
  count = var.auth != null ? 1 : 0
  name  = "AmazonSageMaker-git-repo-${random_id.secret.hex}"
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  count         = var.auth != null ? 1 : 0
  secret_id     = aws_secretsmanager_secret.secret[0].id
  secret_string = jsonencode(var.auth)
}

resource "aws_sagemaker_code_repository" "private_code_repository" {
  count                = var.auth != null ? 1 : 0
  code_repository_name = local.repo_name

  git_config {
    repository_url = var.repository_url
    secret_arn     = aws_secretsmanager_secret.secret[0].arn
  }

  depends_on = [aws_secretsmanager_secret_version.secret_version[0]]
}

resource "aws_sagemaker_code_repository" "public_code_repository" {
  count                = var.auth != null ? 0 : 1
  code_repository_name = local.repo_name

  git_config {
    repository_url = var.repository_url
  }
}
