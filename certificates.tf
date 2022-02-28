resource "aws_acm_certificate" "domain_cert" {
  provider = aws.us-east-1
  domain_name       = var.hosted_zone
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  name = tolist(aws_acm_certificate.domain_cert.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.domain_cert.domain_validation_options)[0].resource_record_type
  zone_id = var.hosted_zone_id
  records = [tolist(aws_acm_certificate.domain_cert.domain_validation_options)[0].resource_record_value]
  ttl = 60
}

resource "aws_acm_certificate_validation" "domain_cert_validation" {
  provider = aws.us-east-1
  certificate_arn         = aws_acm_certificate.domain_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}
