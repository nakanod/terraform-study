resource "aws_acm_certificate" "example-com" {
  domain_name = "*.example.com"
  subject_alternative_names = ["example.com"]
  validation_method = "DNS"
  tags = {
    Name = "example.com"
  }
}

data "aws_route53_zone" "example-com" {
  name = "example.com."
  private_zone = false
}

resource "aws_route53_record" "example-com-validation" {
  name = aws_acm_certificate.example-com.domain_validation_options.0.resource_record_name
  type = aws_acm_certificate.example-com.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.example-com.id
  records = [aws_acm_certificate.example-com.domain_validation_options.0.resource_record_value]
  ttl = 60
}

resource "aws_acm_certificate_validation" "example-com" {
  certificate_arn = aws_acm_certificate.example-com.arn

  validation_record_fqdns = [
    aws_route53_record.example-com-validation.fqdn,
  ]
}
