output "public_instance_ip" {
  value = module.ec2_s3.public_instance_ip
}

output "bucket_name" {
  value = module.ec2_s3.bucket_name
}
