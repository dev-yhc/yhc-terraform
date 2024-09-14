output "zone_id" {
  description = "zone_id for hosting zone"
  value = aws_route53_zone.pulling_in.zone_id
}