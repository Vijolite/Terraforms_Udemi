
#----------------------------------------------------------
# My Terraform
#
# Create:
#    - Security Group for Web Server
#    - Launch Configuration with Auto AMI Lookup
#    - Auto Scaling Group using 2 Availability Zones
#    - Classic Load Balancer in 2 Availability Zones
#-----------------------------------------------------------

provider "aws" {
  region = "ca-central-1"

}

data "aws_availability_zones" "available" {}

data "aws_ami" "latest_linux" {
  owners      = ["137112412989"] //find ami for linux ec2, serch Images->Public Images and take info from there
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"] //find ami for linux ec2, serch Images->Public Images and take info from there
  }
}

#-------------------
resource "aws_default_vpc" "default" {} # This need to be added since AWS Provider v4.29+ to get VPC id

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.available.names[1]
}

#-------------------
resource "aws_security_group" "my_webserver" {
  name   = "Dynamic Security Group"
  vpc_id = aws_default_vpc.default.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress { #output
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dynamic Security Groups"
  }
}

#-------------------
resource "aws_launch_configuration" "web" {
  //name            = "WebServer-Highly-Available"
  name_prefix     = "WebServer-Highly-Available-"
  image_id        = data.aws_ami.latest_linux.id
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.my_webserver.id]
  user_data       = file("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  min_size             = 2 //number of servers
  max_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id] //list of subnet id
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name   = "Web Server in ASG"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  # tags = [
  #   {
  #     key                 = "Name"
  #     value               = "WebServer-in-ASG"
  #     propagate_at_launch = true
  #   },
  #   {
  #     key                 = "Owner"
  #     value               = "Ija S"
  #     propagate_at_launch = true
  #   },
  # ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "WebServer-HA-ELB"
  availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  security_groups    = [aws_security_group.my_webserver.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   timeout             = 3
  #   target              = "HTTP:80/"
  #   interval            = 10
  # }
  tags = {
    Name = "Webserver-Healthy-Available_EBL"
  }
}

output "web_loadbalancer_url" {
  value = aws_elb.web.dns_name
}
