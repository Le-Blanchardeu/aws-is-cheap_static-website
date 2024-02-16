data "aws_route53_zone" "website_domain" {
  count = var.custom_dn ? 1 : 0
  name  = "${var.domain_and_bucket_name}."
}

# Pointing the domain name to the cloudfront distribution
resource "aws_route53_record" "website_rootdomain" {
  count   = var.custom_dn ? 1 : 0
  zone_id = data.aws_route53_zone.website_domain[0].zone_id
  name    = var.domain_and_bucket_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_rootdomain[0].domain_name
    zone_id                = aws_cloudfront_distribution.website_rootdomain[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_subdomain" {
  count   = var.custom_dn ? 1 : 0
  zone_id = data.aws_route53_zone.website_domain[0].zone_id
  name    = "www.${var.domain_and_bucket_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.website_subdomain[0].domain_name
    zone_id                = aws_cloudfront_distribution.website_subdomain[0].hosted_zone_id
    evaluate_target_health = false
  }
}