## terragrunt configuration

locals {
    # Load account and region variables
    account_vars    = read_terragrunt_config(find_in_parent_folders("account.hcl"))
    region_vars     = read_terragrunt_config(find_in_parent_folders("region.hcl"))

    aws_region      = local.region_vars.locals.aws_region
    aws_account_id  = local.account_vars.locals.aws_account_id
    environment     = local.account_vars.locals.environment
}

# Generate AWS account specific provider block.
# Do assume_role to AWS Organizations default role
generate "provider" {
    path    = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents  = <<EOF
provider "aws" {
    region = "${local.aws_region}"
    assume_role {
        role_arn = "arn:aws:iam::${local.aws_account_id}:role/OrganizationAccountAccessRole"
    }

    default_tags {
        tags = {
            account = "${local.aws_account_id}"
            environment = "${local.environment}"
        }
    }
}
EOF
}

# Region specific Terraform state configuration 
remote_state {
    backend = "s3"
    generate = {
        path    = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        encrypt = true
        bucket  = "markusdev-shared-tf-states-${local.aws_region}"
        key     = "${path_relative_to_include()}/terraform.tfstate"
        region  = local.aws_region
        dynamodb_table  = "shared-terraform-locks"
    }
}

#Combine all variables
inputs = merge(
    local.account_vars.locals,
    local.region_vars.locals,
)