resource "aws_s3_bucket" "test123_s3" {
  bucket = var.bucket_name
  tags = {
    "Environment" = var.tag_environment
    "Name"        = var.tag_name
  }
}

# website static hosting config
resource "aws_s3_bucket_website_configuration" "test123_website" {
  bucket = aws_s3_bucket.test123_s3.bucket
  index_document {
    suffix =  "index.html"
  }
}

# cloudfront identity to make it restrict to access at s3 content
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access identity for test123.app"
}

# policy to access s3 and principals must not be *
data "aws_iam_policy_document" "test123_s3_policy" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.test123_s3.arn}/*"]
    principals {
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
      type = "AWS"
    }
  }
}

resource "aws_s3_bucket_policy" "test123_s3_policy" {
  bucket = aws_s3_bucket.test123_s3.bucket
  policy = data.aws_iam_policy_document.test123_s3_policy.json
}

resource "aws_s3_bucket_public_access_block" "test123_s3_public_access" {
  bucket = aws_s3_bucket.test123_s3.bucket

  block_public_acls       = true
  block_public_policy     = true
}

# upload html all files
resource "aws_s3_object" "dist_html" {
  for_each = fileset("${var.folder_path}", "**/*.html")

  bucket = aws_s3_bucket.test123_s3.bucket
  key    = each.value
  source = "${var.folder_path}${each.value}"
  etag   = filemd5("${var.folder_path}${each.value}")
  content_type = "text/html"
}

# upload js all files
resource "aws_s3_object" "dist_js" {
  for_each = fileset("${var.folder_path}", "**/*.js")

  bucket = aws_s3_bucket.test123_s3.bucket
  key    = each.value
  source = "${var.folder_path}${each.value}"
  etag   = filemd5("${var.folder_path}${each.value}")
  content_type = "application/javascript"
}

# upload css all files
resource "aws_s3_object" "dist_css" {
  for_each = fileset("${var.folder_path}", "**/*.css")

  bucket = aws_s3_bucket.test123_s3.bucket
  key    = each.value
  source = "${var.folder_path}${each.value}"
  etag   = filemd5("${var.folder_path}${each.value}")
  content_type = "text/css"
}

# upload image ico all files
resource "aws_s3_object" "dist_ico" {
  for_each = fileset("${var.folder_path}", "**/*.ico")

  bucket = aws_s3_bucket.test123_s3.bucket
  key    = each.value
  source = "${var.folder_path}${each.value}"
  etag   = filemd5("${var.folder_path}${each.value}")
  content_type = "image/x-icon"
}

# Print the files processed so far
output "fileset-results" {
  value = fileset("${var.folder_path}", "**/*")
}