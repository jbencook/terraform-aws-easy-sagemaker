# Example: inline polices

You can easily add inline policies to your execution role. Just write each one into its own JSON file and pass a set of the policy paths as the `inline_policies` parameter in the `execution-role` module. For example:

```hcl
module "execution_role" {
  source  = "jbencook/easy-sagemaker/aws//modules/execution-role"
  version = "0.0.2"

  # You can add any policy ARNs that already exist.
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonRekognitionFullAccess"
  ]

  # Or you can define custom inline policies as JSON documents.
  # Just pass in a set (or list) of the file locations.
  inline_policies = fileset(path.module, "policies/*.json")
}
```

The `fileset` function from Terraform creates a set of file paths with the pattern defined as the second argument. Notice, we can also add any pre-defined policy ARNs. This one adds a managed policy that grants full access to Rekognition, but you can use any ARNs you want.
