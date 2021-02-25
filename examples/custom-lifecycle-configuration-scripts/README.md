# Example: custom lifecycle configuration scripts

If one of the [named lifecycle configuration scripts](https://github.com/jbencook/terraform-aws-easy-sagemaker/tree/main/modules/lifecycle-configuration) doesn't fit your needs, you can write your own scripts to be executed on start or on creation. These scripts will get copied into the main script by the `lifecycle-configuration` module. For example:

```hcl
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
```

Notice you can mix and match named scripts and the custom scripts. To add custom scripts, just include the path to the script you want to use.

This example runs the `./scripts/hello-world-on-create.sh` on creation which writes `"hello world"` to a file in the `~/SageMaker` directory on the instance. On start, it runs the `time_to_live` script (and configures it to shut the instance down after 10 minutes) and runs the `./scrpts/install-omegaconf-on-start.sh` script which installs the `omegaconf` python package into the `Python 3` conda environment.