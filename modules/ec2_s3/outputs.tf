output "public_instance_ip" {
  value = aws_instance.instance.public_ip
}

output "bucket_name" {
  value = aws_s3_bucket.s3_bucket.bucket
}
