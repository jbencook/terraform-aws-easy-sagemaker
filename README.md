# Easy SageMaker

Easy configuration for SageMaker notebook instances.

These modules simplify the creation of SageMaker notebook instances and the resources they need (e.g. secrets, git repos, IAM roles). The most important module is [ezsm-lifecycle-configuration](./modules/ezsm-lifecycle-configuration/) which provides an easy way to deploy parameterized lifecycle configuration scripts to run on instance creation or instance start.

## Pre-requisites

You need a couple tools on your machine to use easy SageMaker:

* Configure AWS CLI (or an appropriate IAM role if you're running this in the cloud)
* Terraform>=0.14

## Quick start

The [example in the root directory](./main.tf) creates a notebook instance with SSH access (through ngrok) that lives for 10 minutes before shutting itself off. To run it in your account there are a couple requirements in addition to the [pre-requisites](#pre-requisites):

1. An ngrok account (you'll need the auth token)
2. A public SSH key

Follow these steps to deploy an instance:

1. Copy and paste the following into a file called `./secrets.tfvars`:

    ```
    ngrok_auth_token = "<ngrok auth token>"
    ngrok_public_keys = [
        "<ssh public key>",
    ]
    ```

2. Add your ngrok auth token and public SSH key into the appropriate places in `./secrets.tfvars`. These will be stored as secrets in AWS SecretsManager. Notice the `ngrok_public_keys` variable is an array. You can add multiple public keys if you want to give access to more than one SSH private key.
3. Initialize Terraform:

    ```
    terraform init
    ```

4. Apply the Terraform configuration:

    ```
    terraform apply -var-file=secrets.tfvars
    ```

When the apply finishes, you should see an instance called `ezsm` (aka "easy SageMaker") in your notebook instances list view. You can login to ngrok to see the host and port you can connect to for SSH access.

<!-- Example -->

If you don't want to setup SSH on your instance, check out [other examples](./examples/).

## Why do these exist?

Terraform recommends _not_ writing thin wrappers around single resources. This is good advice for people who are comfortable with Terraform. If that's you, then you probably won't find the [ezsm-code-repository](./modules/ezsm-code-repository/) or [ezsm-execution-role](./modules/ezsm-ezsm-execution-role/) modules very helpful. No problem! You should feel free to use the managed lifecycle configuration scripts in the [ezsm-lifecycle-configuration](./modules/ezsm-lifecycle-configuration/) module alone.

But if you're new to Terraform, you might not want to think about conditionals for public vs private repos or looping through JSON files to add policies to your IAM role. You should know that the code repository and execution role modules aren't doing very complex and you can go straight to the AWS provider if you prefer. They're only included in this project to lower the barrier to using Terraform to manage your notebook instances.
