# -----------------------------------
# TERRAGRUNT CONFIGURATION
# -----------------------------------


# -----------------------------------
# Include the root terragrunt.hcl configurations
# -----------------------------------
include "root" {
    path = find_in_parent_folders()
}

locals {
    base_source = "${dirname(find_in_parent_folders())}/..//modules"
}

terraform {
    source = local.base_source
}