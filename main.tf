provider "aws" {
  region = "us-east-1"
}

resource "aws_wafv2_web_acl" "bot-control" {
  name  = "bot-control"
  scope = "REGIONAL"
  default_action {
    block {}
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "bot-control-metric"
    sampled_requests_enabled   = true
  }
  rule {
    name     = "AWSManagedRulesBotControlRuleSet-test"
    priority = 8
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesBotControlRuleSet"
        vendor_name = "AWS"

        scope_down_statement {
          byte_match_statement {
            search_string = "/test"
            field_to_match {
              uri_path {}
            }
            text_transformation {
              priority = 0
              type     = "NONE"
            }
            positional_constraint = "CONTAINS"
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "bot-control-metric"
      sampled_requests_enabled   = true
    }
  }



}
