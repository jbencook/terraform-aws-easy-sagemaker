# Easy SageMaker

Easy configuration for SageMaker notebook instances.

These modules simplify the creation of SageMaker notebook instances and the resources they need (e.g. secrets, git repos, IAM roles). The most important module is [ezsm-lifecycle-configuration](./modules/ezsm-lifecycle-configuration/) which provides an easy way to deploy parameterized lifecycle configuration scripts to run on instance creation or instance start.

## Pre-requisites

There are two pre-requisites for using the easy SageMaker modules:

* [Install](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and [configure](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html) AWS CLI
* Download and install [Terraform>=0.14](https://www.terraform.io/downloads.html)

## Quick start

The [example in the root directory](./main.tf) creates a notebook instance with SSH access (through [ngrok](https://ngrok.com/)) that lives for 10 minutes before shutting itself off. To run it in your account there are a couple requirements in addition to the [pre-requisites](#pre-requisites):

1. An ngrok account (you'll need your [Authtoken](https://dashboard.ngrok.com/auth/your-authtoken))
2. An SSH [public key](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-2)

Then, follow these steps to deploy an instance:

1. Copy and paste the following into a file called `./secrets.tfvars`:

    ```
    ngrok_authtoken = "<ngrok authtoken>"
    ngrok_public_keys = [
        "<ssh public key>",
    ]
    ```
2. Add your ngrok authtoken and SSH public key into the appropriate places in `./secrets.tfvars`. The `ezsm-lifecycle-configuration` module  will store these as secrets in AWS Secrets Manager. Notice the `ngrok_public_keys` variable is an array. You can add multiple public keys if you want to give access to more than one SSH private key.
3. Initialize Terraform:

    ```
    terraform init
    ```
4. Apply the Terraform configuration:

    ```
    terraform apply -var-file=secrets.tfvars
    ```

    If you need to use an AWS profile other than default, you can set it as an environment variable, for example:

    ```
    AWS_PROFILE=jbencook terraform apply -var-file=secrets.tfvars
    ```

    When the apply finishes, you should see an instance called `ezsm` (aka "easy SageMaker") in your notebook instances [list view](https://console.aws.amazon.com/sagemaker/home#/notebook-instances).
5. Login to your [ngrok dashboard](https://dashboard.ngrok.com/status/tunnels) to see the host and port for your SSH connection. The user is `ec2-user`. So for example, if the URL of your tunnel is `tcp://4.tcp.ngrok.io:15954`, you can connect with the following:

    ```
    ssh -p 15954 ec2-user@4.tcp.ngrok.io
    ```

If you don't want to setup SSH on your instance, check out [other examples](./examples/).

## Why Easy SageMaker Terraform modules?

Terraform recommends _not_ writing thin wrappers around single resources. This is good advice for people who are comfortable with Terraform. If that's you, then you probably won't find the [ezsm-code-repository](./modules/ezsm-code-repository/) or [ezsm-execution-role](./modules/ezsm-ezsm-execution-role/) modules particularly helpful. No problem! Feel free to use the managed lifecycle configuration scripts in the [ezsm-lifecycle-configuration](./modules/ezsm-lifecycle-configuration/) module by itself.

But if you're new to Terraform, you might not want to think about conditionals for public vs private repos or looping through JSON files to add policies to your IAM role. The code repository and execution role modules aren't doing very complex work and you can go straight to the AWS provider for IAM roles and git repositories if you prefer. They're only included in this project to lower the barrier to entry for people who want managed notebook instances.
