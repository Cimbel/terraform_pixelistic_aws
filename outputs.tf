output "backend_url" {
  value = aws_elastic_beanstalk_environment.pixelapp-env-test.cname
}

output "frontend_url" {
  value = "https://${aws_s3_bucket.pixelapp_bucket.bucket_regional_domain_name}/pixelapp_fe/build/index.html"
}