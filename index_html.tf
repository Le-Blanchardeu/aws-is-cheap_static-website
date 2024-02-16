# An basic index.html file uploaded in your S3
# Delete this terraform file when you have uploaded your real website content
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.website_subdomain.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}

resource "local_file" "index_html" {
  filename = "${path.module}/index.html"
  content  = <<EOF
<html>
<head><title>${var.domain_and_bucket_name}</title></head>
<body style="background-color:black; color:white; text-align: center">
<h1>Welcome to ${var.domain_and_bucket_name}</h1>
<p>Site under construction...</p>
</body>
</html>
EOF
}