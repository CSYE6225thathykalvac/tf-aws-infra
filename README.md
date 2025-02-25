   # tf-aws-infra
## prerequisites
- Terraform
- AWS CLI
- Git

## Setting up AWS Profiles
1. create `demo` and `dev` accounts and setup profiles in local system 
2. `aws configure --profile dev` for dev account
    `aws configure -- profile demo` for demo account
3. we can verify configuration files using the following commands: `vi ~/.aws/config` `vi ~/.aws/credentials`
4. we can add the following line in command to make infra in changes in a certain profile: `AWS_PROFILE=dev/demo`

## AWS Infrastructure Components
- **VPC**: Creates a Virtual Private Cloud.
- **Subnets**: Public and private subnets across Availability Zones.
- **Route Tables**: Configures public and private route tables.
- **Internet Gateway**: Enables internet access for public subnets.

## Running Terraform Scripts
1. to run terrafro  scripts first navigate into the scripts folder
2. `terrafrom init`
3. `terraform fmt`
4. `$env:AWS_PROFILE="demo"; terraform plan`
5. `$env:AWS_PROFILE="demo"; terraform apply`
6. `$env:AWS_PROFILE="demo"; terraform destroy`

## 1. Terraform CI
- Runs on `ubuntu-latest`.
- Performs the following steps:
  1. **Checkout repository**: Clones the repository to the GitHub runner.
  2. **Setup Terraform**: Installs the latest version of Terraform.
  3. **Terraform Format Check**: Ensures that all Terraform files follow the proper formatting using `terraform fmt -check -recursive`.
  4. **Terraform Init**: Initializes Terraform by downloading necessary provider plugins.
  5. **Terraform Validate**: Checks the validity of the Terraform configuration files.
