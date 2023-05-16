output "webserver_instanceid" {
  value = aws_instance.my_webserver.id
}

output "webserver_public_ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "webserver_sec_group_id" {
  value = aws_security_group.my_webserver.id
}

output "webserver_sec_group_arn" {
  value       = aws_security_group.my_webserver.arn
  description = "This is security group arn" #comment
}
