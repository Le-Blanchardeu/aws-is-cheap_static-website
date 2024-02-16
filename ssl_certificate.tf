# Create ssl certification for our domain
resource "aws_acm_certificate" "website_ssl_certificate" {
  count                     = var.custom_dn ? 1 : 0
  provider                  = aws.us-east-1
  domain_name               = var.domain_and_bucket_name
  subject_alternative_names = ["*.${var.domain_and_bucket_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Creation the DNS record for validation
resource "aws_route53_record" "validations" {
  for_each = (
    var.custom_dn == true ?
    { for dvo in aws_acm_certificate.website_ssl_certificate[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    } } : {}
  )

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.website_domain[0].zone_id
}

# Auto validate the certificate with dns records
resource "aws_acm_certificate_validation" "website_cert" {
  count                   = var.custom_dn ? 1 : 0
  provider                = aws.us-east-1
  certificate_arn         = aws_acm_certificate.website_ssl_certificate[0].arn
  validation_record_fqdns = [for record in aws_route53_record.validations : record.fqdn]
}