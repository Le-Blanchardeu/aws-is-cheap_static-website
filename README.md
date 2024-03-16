# AWS IS CHEAP : Deploy very quickly a Static Website on AWS

In the life of a computer engineer, you are usually asked three things by your close ones:

- Fix the Wi-Fi
- Fix the printer
- Make them a website

This project helps you save a big amount of time on the latest.

## Pre-requisites

- An AWS Account
- Terraform installed on your computer with AWS credentials setup (API key in environment variables or any other technique)
- (Optional: AWS Cli installed)
- (Optional: A Custom Domain Name in AWS Route53)

## Deployment options

### Static Website hosted on S3

Your 12 years old nephew created a monster truck website and wants "to have it on the internet" to impress his little comrades.
The following will create a static website on S3, no https, no custom domain name.

```sh
terraform init
terraform apply -var="domain_and_bucket_name=mega-super-monster-trucks.com" -var="aws_region=eu-west-1"
# Replace mega-super-monster-trucks.com by a bucket name you like (should be unique in the world)
# Replace eu-west-1 (Ireland) with another AWS region if you wish

# Pushing the website in the S3 if you have aws cli installed. Otherwise open AWS Console, select S3, and pu the website content in the bucket 
# (there must be an index.html)
aws s3 cp nephew_monster_truck_website/ s3://mega-super-monster-trucks.com/ --recursive
```

Here you go. Maybe your nephew won't get bullied again tomorrow after that.

### Static Website hosted on S3 with HTTPS

Your 20 years old wanna-be superstar sister wants to create a personal blog that will link to her instagram, tiktok and facebook page and she ABSOLUTELY needs https because she read somewhere it improves SEO.
The following will create a static website on S3, with https, no custom domain name.

```sh
terraform init
terraform apply -var="domain_and_bucket_name=sister_beauty.com" -var="aws_region=eu-west-1" -var="https=true"
# Replace sister_beauty.com by a bucket name you like (should be unique, like an email address... or your wife)
# Replace eu-west-1 (Ireland) with another AWS region if you wish

# Pushing the website in the S3 if you have aws cli installed. Otherwise open AWS Console, select S3, and pu the website content in the bucket 
# (there must be an index.html)
aws s3 cp sister_website/ s3://sister_beauty.com/ --recursive

# NOTE: in case you modify your webpage (e.g. the index.html) and want to see your modifications immediately, you will need to invalidate the cloudfront cache:
aws cloudfront create-invalidation — distribution-id E1xxxxxxxxxx — paths “/index.html”
```

### Static Website hosted on S3 with HTTPS with Custom Domain Name

Your brother-in-law is considering himself as a "crypto visionary" and wants to have its own crypto launch bootstrap page. Your sister orders you to help him with that. He even bought a custom domain name on AWS Route 53!
The following will create a static website on S3, with https and custom domain name.

```sh
terraform init
terraform apply -var="domain_and_bucket_name=feetfetishcrypto.com" -var="aws_region=eu-west-1" -var="https=true" -var="custom_dn=true"
# Replace feetfetishcrypto.com by the domain name bought in AWS Route 53
# Replace eu-west-1 (Ireland) with another AWS region if you prefer

# Pushing the website in the S3 if you have aws cli installed. Otherwise open AWS Console, select S3, and pu the website content in the bucket 
# (there must be an index.html)
aws s3 cp crypto_bootstrap_page/ s3://www.feetfetishcrypto.com/ --recursive

# NOTE: in case you modify your webpage (e.g. the index.html) and want to see your modifications immediately, you will need to invalidate the cloudfront cache:
aws cloudfront create-invalidation — distribution-id E1xxxxxxxxxx — paths “/index.html”
```

## How to contribute

If you find any bug or improvement and you want to contribute, you can:

- Email me. Or:
- Fork the project and create a pull request

## IMPORTANT NOTE

The bucket mentioned in the commands will automatically be created. If you already own the bucket and want to use it for your website,
type in the following commands in this project folder:

```sh
terraform import 'aws_s3_bucket.website_root_domain' name-of-your-root-bucket # (ex: mysuperwebsite.com)

# And potentially for the static website with https and custom domain name: 
terraform import 'aws_s3_bucket.website_subdomain' name-of-your-subdomain-bucket # (ex: www.mysuperwebsite.com)
```
