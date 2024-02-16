# AWS is Cheap - Deploy a Customizable S3 Static Website

## Aim of this project

The goal is to deploy automatically, via terraform, a static website hosted on S3. You can also do it manually from here:
<https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/getting-started-s3.html>
Or deploy it automatically with this project and a few command lines.

## Pre-requisites

- You must own a AWS admin account, along with API credentials.
- Terraform must be installed and setup. More info here <https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli>
- (Optional) A Custom Domain Name bought and hosted on Route53

## Option 1 - A simple static website hosed on S3

[X] Static hosting on S3
[] Cloudfront
[] HTTPS
[] Custom Domain Name
[] Email sending / receiving from Custom Domain Name
[] Make it Dynamic

Pull this project, replace 'name-of-your-bucket' with the name of your bucket and 'eu-west-1' with the AWS region you want to use and run the following commands:

```sh
terraform init

# if you already own the bucket you want to use, you need to import it into terraform
terraform import 'aws_s3_bucket.website_subdomain' name-of-your-bucket # (ex: mysuperwebsite.com)
# end

terraform plan -out=tfplan -var="domain_and_bucket_name=name-of-your-bucket" -var="aws_region=eu-west-1"
terraform apply tfplan
```

Your website url should be displayed at the end of the terraform apply process.

## Option 2 - A simple static website with HTTPS

[X] Static hosting on S3
[X] Cloudfront
[X] HTTPS
[] Custom Domain Name
[] Email sending / receiving from Custom Domain Name

```sh
terraform init

# if you already own the bucket you want to use, you need to import it into terraform
terraform import 'aws_s3_bucket.website_subdomain' name-of-your-bucket # (ex: mysuperwebsite.com)
# end

terraform plan -out=tfplan -var="domain_and_bucket_name=name-of-your-bucket" -var="aws_region=eu-west-1" -var="https=true"
terraform apply tfplan
```

## Option 3 - A simple static website with HTTPS and Custom Domain Name

[X] Static hosting on S3
[X] Cloudfront
[X] HTTPS
[X] Custom Domain Name
[] Email sending / receiving from Custom Domain Name

```sh
terraform init

# if you already own the bucket you want to use, you need to import it into terraform
terraform import 'aws_s3_bucket.website_subdomain' name-of-your-bucket # (ex: mysuperwebsite.com)
# end

terraform plan -out=tfplan -var="domain_and_bucket_name=name-of-your-bucket" -var="aws_region=eu-west-1" -var="https=true" -var="custom_dn=true"
terraform apply tfplan
```

## Option 4 - A simple static website with HTTPS, Custom Domain Name and email sending/receiving

[X] Static hosting on S3
[X] Cloudfront
[X] HTTPS
[X] Custom Domain Name
[X] Email sending / receiving from Custom Domain Name

```sh
terraform init

# if you already own the bucket you want to use, you need to import it into terraform
terraform import 'aws_s3_bucket.website_subdomain' name-of-your-bucket # (ex: mysuperwebsite.com)
# end

terraform plan -out=tfplan -var="domain_and_bucket_name=name-of-your-bucket" -var="aws_region=eu-west-1" -var="https=true" -var="custom_dn=true" -var="email_mgmt=true"
terraform apply tfplan
```
