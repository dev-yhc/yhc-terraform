output "arn" {
  description = "The ID and ARN of s3"
  value = aws_s3_bucket.public_read_bucket.arn
}