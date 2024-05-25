output "vpc_tags" {
  description = "The Tag of the VPC"
  value       = aws_vpc.this.*.tags[0]
  #value       = "${lookup(aws_vpc.this.*.tags[0],"Name")}"
}

output "vpc_name_prefix" {
  # Example : "hakuna-prod-an2"
  description = "The prefix name of vpc tag name"
  value       = element(split("-vpc",lookup(aws_vpc.this.*.tags[0],"Name")),0)
}

output "tag_product" {
  # Example : "hakuna" "azar"
  description = "The product name of vpc tag name"
  value       = element(split("-",lookup(aws_vpc.this.*.tags[0],"Name")),0)
}

output "tag_stack" {
  # Example : "prod" "dev"
  description = "The stack name of vpc tag name"
  value       = element(split("-",lookup(aws_vpc.this.*.tags[0],"Name")),1)
}

output "region_short_name" {
  # Example : "an2" "ec1"
  description = "The region shorten name of vpc tag name"
  value       = element(split("-",lookup(aws_vpc.this.*.tags[0],"Name")),2)
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.this.*.id, [""])[0]
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = concat(aws_vpc.this.*.arn, [""])[0]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
}
