provider "aws" {
region = "ap-south-1"
profile = "shailly_shah"
}
resource "aws_s3_bucket" "my-test-s3-terraform-bucket-shaillys3" {
bucket = "my-test-s3-terraform-bucket-shaillys3"
tags = {
Name = "my-test-s3-terraform-bucket-shaillys3"
}
}
resource "aws_cloudfront_distribution" "s3_distribution" {
origin {
domain_name ="${aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3.bucket_regional_domain_name}"
origin_id ="${aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3.id}"
}
enabled = true
is_ipv6_enabled = true
comment = "S3 bucket"
default_cache_behavior {
allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS",
"PATCH", "POST", "PUT"]
cached_methods = ["GET", "HEAD"]
target_origin_id ="${aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3.id}"
forwarded_values {
query_string = false
cookies {
forward = "none"
}
}
viewer_protocol_policy = "allow-all"
min_ttl = 0
default_ttl = 3600
max_ttl = 86400
}
# Cache behavior with precedence 0
ordered_cache_behavior {
path_pattern = "/content/immutable/*"
allowed_methods = ["GET", "HEAD", "OPTIONS"]
cached_methods = ["GET", "HEAD", "OPTIONS"]
target_origin_id ="${aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3.id}"
forwarded_values {
query_string = false
cookies {
forward = "none"
}
}
min_ttl = 0
default_ttl = 86400
max_ttl = 31536000
compress = true
viewer_protocol_policy = "redirect-to-https"
}
restrictions {
geo_restriction {
restriction_type = "whitelist"
locations = ["IN"]
}
}
tags = {
Environment = "production"
}
viewer_certificate {
cloudfront_default_certificate = true
}
depends_on = [
aws_s3_bucket.my-test-s3-terraform-bucket-shaillys3
]
}