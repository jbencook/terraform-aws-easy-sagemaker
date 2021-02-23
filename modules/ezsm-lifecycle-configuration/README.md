# Easy SageMaker Lifecycle Configuration

This module manages lifecycle configuration scripts for SageMaker notebook instances. In addition to deploying custom scripts, it comes with a handful of general purpose scripts that can be configured.

## Named Scripts

The following scripts can be configured and added to a managed lifecycle configuration:

* [auto_stop](./scripts/auto-stop.sh): automatically stop a notebook instance after `idle_time` seconds without notebook activity
* [github_config](./scripts/github-config.sh): configure the username and e-mail address for a git user
* [ngrok_ssh](./scripts/ngrok-ssh.sh): setup a TCP ngrok tunnel to allow SSH access to a notebook instance
* [stop_at](./scripts/stop-at.sh): automatically stop a notebook instance at `stop_time` in UTC
* [time_to_live](./scripts/time-to-live.sh): automatically stop a notebook instance after `duration` time

## Usage

```hcl
module "simple_lifecycle_config" {
  source = "github.com/jbencook/terraform-aws-easy-sagemaker//modules/ezsm-lifecycle-configuration"

  github_config = {
    username = "jbencook"
    email    = "jbenjamincook@gmail.com"
  }

  on_create = [
    "./foo-bar.sh",
  ]

  on_start = [
    "github_config",
    "./hello-world.sh",
  ]
}
```

The `on_create` and `on_start` parameters take lists of scripts. Scripts can be one of the [named configurable scripts](#named-scripts) (like `github_config`) or the path to a custom script relative to the working directory. When including a named script, you should also include a parameter with the same name. So for example, the `github_config` script requires a `github_config` object with `username` and `email`. You can see the required configuration objects for each of the named scripts in [./variables.tf](./variables.tf).
