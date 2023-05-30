output "server_instanceid" {
  value = aws_instance.my_server.id
}

output "server_public_ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "webserver_sec_group_id" {
  value = aws_security_group.my_webserver.id
}

