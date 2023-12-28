## tf s3 resources

resource "aws_s3_bucket" "bucket" {
    bucket_prefix = "${var.bucket_name_prefix}-${var.environment}-${var.aws_region}"
    force_destroy = true
}