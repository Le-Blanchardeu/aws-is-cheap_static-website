data "aws_cloudfront_cache_policy" "aws_caching_optimized" {
  count = var.https ? 1 : 0
  name  = "Managed-CachingOptimized"
}

# Cloudfront distribution for the subdomain (wwww)
resource "aws_cloudfront_origin_access_control" "website_subdomain" {
  count                             = var.https ? 1 : 0
  name                              = "www.${var.domain_and_bucket_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website_subdomain" {
  count = var.https ? 1 : 0
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "www.${var.domain_and_bucket_name}.s3-website-${var.aws_region}.amazonaws.com"
    origin_id           = "www.${var.domain_and_bucket_name}"

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  http_version        = "http2and3"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_200"

  default_cache_behavior {
    cache_policy_id  = data.aws_cloudfront_cache_policy.aws_caching_optimized[0].id
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "www.${var.domain_and_bucket_name}"

    viewer_protocol_policy = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.custom_dn ? false : true
    acm_certificate_arn            = var.custom_dn ? aws_acm_certificate.website_ssl_certificate[0].arn : null
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  aliases = var.custom_dn ? ["www.${var.domain_and_bucket_name}"] : null

}


# Cloudfront distribution for the root domain
resource "aws_cloudfront_origin_access_control" "website_rootdomain" {
  count                             = var.custom_dn ? 1 : 0
  name                              = var.domain_and_bucket_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website_rootdomain" {

  count = var.custom_dn ? 1 : 0

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = "${var.domain_and_bucket_name}.s3-website-${var.aws_region}.amazonaws.com"
    origin_id           = var.domain_and_bucket_name

    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }


  http_version    = "http2and3"
  enabled         = true
  is_ipv6_enabled = true
  price_class     = "PriceClass_200"

  default_cache_behavior {
    cache_policy_id  = data.aws_cloudfront_cache_policy.aws_caching_optimized[0].id
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.domain_and_bucket_name

    viewer_protocol_policy = "redirect-to-https"

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.website_ssl_certificate[0].arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  aliases = ["${var.domain_and_bucket_name}"]

}