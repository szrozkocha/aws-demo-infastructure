resource "aws_acm_certificate" "cloudfront_cert" {
  provider = aws.us-east-1
  domain_name       = var.hosted_zone
  subject_alternative_names = ["www.${var.hosted_zone}"]
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cloudfront_cert_validation" {
  name = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_type
  zone_id = var.hosted_zone_id
  records = [tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[0].resource_record_value]
  ttl = 60
}

resource "aws_route53_record" "www_cloudfront_cert_validation" {
  name = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[1].resource_record_name
  type = tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[1].resource_record_type
  zone_id = var.hosted_zone_id
  records = [tolist(aws_acm_certificate.cloudfront_cert.domain_validation_options)[1].resource_record_value]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cloudfront_cert_validation" {
  provider = aws.us-east-1
  certificate_arn         = aws_acm_certificate.cloudfront_cert.arn
  validation_record_fqdns = [aws_route53_record.cloudfront_cert_validation.fqdn, aws_route53_record.www_cloudfront_cert_validation.fqdn]
}


resource "aws_acm_certificate" "beanstalk_cert" {
  provider          = aws
  domain_name       = "api.${var.hosted_zone}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "beanstalk_cert_validation" {
  name = tolist(aws_acm_certificate.beanstalk_cert.domain_validation_options)[0].resource_record_name
  type = tolist(aws_acm_certificate.beanstalk_cert.domain_validation_options)[0].resource_record_type
  zone_id = var.hosted_zone_id
  records = [tolist(aws_acm_certificate.beanstalk_cert.domain_validation_options)[0].resource_record_value]
  ttl = 60
}

resource "aws_acm_certificate_validation" "beanstalk_cert_validation" {
  provider = aws
  certificate_arn         = aws_acm_certificate.beanstalk_cert.arn
  validation_record_fqdns = [aws_route53_record.beanstalk_cert_validation.fqdn]
}