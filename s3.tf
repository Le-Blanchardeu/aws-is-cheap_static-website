# WWW subdomain
resource "aws_s3_bucket" "website_subdomain" {
  bucket = "www.${var.domain_and_bucket_name}"
}

resource "aws_s3_bucket_website_configuration" "website_subdomain" {
  bucket = aws_s3_bucket.website_subdomain.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website_subdomain" {
  bucket                  = aws_s3_bucket.website_subdomain.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_public_access_subdomain" {
  bucket = aws_s3_bucket.website_subdomain.id
  policy = data.aws_iam_policy_document.allow_public_access_subdomain.json
  depends_on = [
    aws_s3_bucket.website_subdomain,
    aws_s3_bucket_public_access_block.website_subdomain,
  ]
}

data "aws_iam_policy_document" "allow_public_access_subdomain" {
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.website_subdomain.arn}/*",
    ]
  }
}

# Root domain
resource "aws_s3_bucket" "website_rootdomain" {
  count  = var.custom_dn ? 1 : 0
  bucket = var.domain_and_bucket_name
}

resource "aws_s3_bucket_website_configuration" "website_rootdomain" {
  count  = var.custom_dn ? 1 : 0
  bucket = aws_s3_bucket.website_rootdomain[0].id
  redirect_all_requests_to {
    host_name = "www.${var.domain_and_bucket_name}"
    protocol  = "https"
  }
}

resource "aws_s3_bucket_policy" "allow_public_access_rootdomain" {
  count  = var.custom_dn ? 1 : 0
  bucket = aws_s3_bucket.website_rootdomain[0].id
  policy = data.aws_iam_policy_document.allow_public_access_rootdomain[0].json
  depends_on = [
    aws_s3_bucket.website_rootdomain[0],
  ]
}

data "aws_iam_policy_document" "allow_public_access_rootdomain" {
  count = var.custom_dn ? 1 : 0
  statement {
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.website_rootdomain[0].arn}/*",
    ]
  }
}