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

## Application Security Group
- Create an EC2 security group for your EC2 instances hosting web applications.
- Add ingress rules to allow TCP traffic on ports 22 (SSH), 80 (HTTP), 443 (HTTPS), and the port on which your application runs from anywhere in the world.
- This security group will be referred to as the application security group.

## EC2 Instance
- Create an EC2 instance with the following specifications. You may go with default values for any parameter not provided in the table below.
- The EC2 instance must be launched in the VPC created by Terraform. You cannot launch the EC2 instance in the default VPC.
- The application security group should be attached to this EC2 instance.
- Ensure that the EBS volumes are terminated when EC2 instances are terminated.

##  certificate import
aws acm import-certificate \
  --certificate fileb://demo_charanreddyt_me.crt \
  --private-key fileb://private.key \
  --certificate-chain fileb://demo_charanreddyt_me.ca-bundle \
  --region us-east-1