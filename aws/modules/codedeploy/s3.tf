# ---------------------------------------
# s3 Bucket
# ---------------------------------------
resource "aws_s3_bucket" "data" {
  bucket = var.data_bucket_name
  tags = var.tags
}