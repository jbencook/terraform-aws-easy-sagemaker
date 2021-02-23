resource "random_id" "ngrok_ssh_secret" {
  keepers = {
    ngrok_ssh_secret = var.ngrok_ssh != null ? jsonencode(var.ngrok_ssh) : ""
  }
  byte_length = 4
}

resource "aws_secretsmanager_secret" "ngrok_ssh_secret" {
  count = var.ngrok_ssh != null ? 1 : 0
  name  = "AmazonSageMaker-ngrok-ssh-${random_id.ngrok_ssh_secret.hex}"
}

resource "aws_secretsmanager_secret_version" "ngrok_ssh_secret_version" {
  count     = var.ngrok_ssh != null ? 1 : 0
  secret_id = aws_secretsmanager_secret.ngrok_ssh_secret[0].id
  secret_string = jsonencode({
    auth_token  = var.ngrok_ssh.auth_token,
    public_keys = join("\n", var.ngrok_ssh.public_keys)
  })
}

locals {
  scripts = {
    github_config = var.github_config != null ? templatefile("${path.module}/scripts/github-config.sh", var.github_config) : ""
    auto_stop     = var.auto_stop != null ? templatefile("${path.module}/scripts/auto-stop.sh", var.auto_stop) : ""
    stop_at       = var.stop_at != null ? templatefile("${path.module}/scripts/stop-at.sh", var.stop_at) : ""
    time_to_live  = var.time_to_live != null ? templatefile("${path.module}/scripts/time-to-live.sh", var.time_to_live) : ""
    ngrok_ssh     = var.ngrok_ssh != null ? templatefile("${path.module}/scripts/ngrok-ssh.sh", { secret_id = aws_secretsmanager_secret.ngrok_ssh_secret[0].id }) : ""
  }

  on_create = join("\n", [for script in var.on_create : contains(keys(local.scripts), script) ? local.scripts[script] : file(script)])
  on_start  = join("\n", [for script in var.on_start : contains(keys(local.scripts), script) ? local.scripts[script] : file(script)])
}

resource "random_id" "scripts" {
  keepers = {
    scripts = join("\n", [local.on_create, local.on_start])
  }
  byte_length = 4
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "scripts" {
  name      = "AmazonSageMaker-lifecycle-configuration-${random_id.scripts.hex}"
  on_create = base64encode(local.on_create)
  on_start  = base64encode(local.on_start)
}
