resource "aws_route53_record" "vercel_A_record" {
  name    = ""
  type    = "A"
  ttl     = 300
  zone_id = data.terraform_remote_state.pullingin_domain.outputs.zone_id
  records = ["76.76.21.21"]
}

resource "aws_route53_record" "vercel_CNAME_record" {
  name    = "www"
  type    = "CNAME"
  ttl     = 300
  zone_id = data.terraform_remote_state.pullingin_domain.outputs.zone_id
  records = ["cname.vercel-dns.com."]
}