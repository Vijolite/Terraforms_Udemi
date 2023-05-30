
#----------------------------------------------------------
# My Terraform
#
# Create:
#    - Security Group for Web Server and ALB
#    - Launch Template with Auto AMI Lookup
#    - Auto Scaling Group using 2 Availability Zones
#    - Application Load Balancer in 2 Availability Zones
#    - Application Load Balancer TargetGroup
#-----------------------------------------------------------

provider "aws" {
  region = "ca-central-1"

  default_tags {
    tags = {
      Owner     = "Ija S"
      CreatedBy = "Terraform"
      Course    = "Udemi: From Zero to Certified Professional - Lesson11"
    }
  }
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

  dynamic "ingress" { //input
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
resource "aws_launch_template" "web" {
  name                   = "WebServer-Highly-Available-LT"
  image_id               = data.aws_ami.latest_linux.id
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = filebase64("${path.module}/user_data.sh")
}

resource "aws_autoscaling_group" "web" {
  name                = "WebServer-Highly-Available-ASG-Ver-${aws_launch_template.web.latest_version}"
  min_size            = 2
  max_size            = 2
  min_elb_capacity    = 2
  health_check_type   = "ELB"
  vpc_zone_identifier = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  target_group_arns   = [aws_lb_target_group.web.arn]

  launch_template {
    id      = aws_launch_template.web.id
    version = aws_launch_template.web.latest_version
  }

  dynamic "tag" {
    for_each = {
      Name   = "WebServer in ASG-v${aws_launch_template.web.latest_version}"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "web" {
  name               = "WebServer-HA-ALB"
  load_balancer_type = "application"
  subnets            = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  security_groups    = [aws_security_group.my_webserver.id]
}

resource "aws_lb_target_group" "web" {
  name                 = "WebServer-HighlyAvailable-TG"
  vpc_id               = aws_default_vpc.default.id
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 10 # seconds
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

output "web_loadbalancer_url" {
  value = aws_lb.web.dns_name
}
