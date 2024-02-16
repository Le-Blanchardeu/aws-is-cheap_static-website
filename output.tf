output "your_website_url" {
  # We display this value only if https is activated
  value       = var.custom_dn ? "www.${var.domain_and_bucket_name}" : var.https ? aws_cloudfront_distribution.website_subdomain[0].domain_name : "${var.domain_and_bucket_name}.s3-website-${var.aws_region}.amazonaws.com"
  description = "Your website url"
}