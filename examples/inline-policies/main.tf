module "execution_role" {
  source  = "jbencook/easy-sagemaker/aws//modules/execution-role"
  version = "0.0.2"

  # You can add any policy ARNs that already exist.
  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonRekognitionFullAccess"
  ]

  # Or you can define custom inline policies as JSON documents.
  # Just pass in a list of the file locations.
  inline_policies = fileset(path.module, "policies/*.json")
}

resource "aws_sagemaker_notebook_instance" "instance" {
  name          = "ezsm-example-inline-policies"
  instance_type = "ml.t2.medium"
  role_arn      = module.execution_role.arn
}
