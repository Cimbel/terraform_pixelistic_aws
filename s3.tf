# bucket for web-hosting frontend part

resource "aws_s3_bucket" "pixelapp_bucket" {
  bucket        = var.webstatic_bucket.name
  tags          = var.tags_for_app
  acl           = var.webstatic_bucket.acl
  policy        = file("policy.json") 
  force_destroy = true

  website {
    index_document = "index.html"
  }
}

# bucket for storing images for app

resource "aws_s3_bucket" "pixelapp_storage" {
  bucket        = var.pixelapp_storage.name
  tags          = var.tags_for_app
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "pixelapp_storage" {
  bucket = aws_s3_bucket.pixelapp_storage.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}