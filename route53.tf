resource "aws_route53_record" "main_route53_to_main_cloudfront" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.hosted_zone
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.main_cloudfront.domain_name
    zone_id = "Z2FDTNDATAQYW2" # CloudFront ZoneID (https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html)
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "main_route53_to_main_beanstalk" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "api.${var.hosted_zone}"
  type    = "A"

  alias {
    name = aws_elastic_beanstalk_environment.beanstalk_app_env.endpoint_url
    zone_id = "Z215JYRZR1TBD5" # Elastic Beanstalk ZoneID (https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-aliastarget.html)
    evaluate_target_health = false
  }
}