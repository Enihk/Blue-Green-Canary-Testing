######### Public: single dashboard domain -> public ALB (weighted v1/v2 behind it) #########

resource "aws_route53_record" "dashboard_alias" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.dashboard_subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.public.dns_name
    zone_id                = aws_lb.public.zone_id
    evaluate_target_health = true
  }
}

######### Private: counting.<internal_domain> -> internal ALB #########

resource "aws_route53_zone" "internal" {
  name = var.internal_domain

  vpc {
    vpc_id = aws_vpc.dash_count_app.id
  }

  tags = { Name = "${var.prefix}-internal-zone" }
}

resource "aws_route53_record" "counting_internal" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "counting.${var.internal_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.counting_internal.dns_name
    zone_id                = aws_lb.counting_internal.zone_id
    evaluate_target_health = true
  }
}
