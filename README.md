# terragrunt_aws_multi_account

This project provisions S3 bucket from Terraform module to three sandbox accounts using Terragrunt.

Before deployment, update `aws_account_id` parameter in `/deployment/accounts/sandbox*/account.hcl` with your AWS account IDs.
```
cd terragrunt_aws_multi_account/deployment/accounts

terragrunt run-all plan
```