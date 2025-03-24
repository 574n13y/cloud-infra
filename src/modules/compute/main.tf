resource "aws_launch_template" "main" {
  name_prefix   = "${var.environment}-template"
  image_id      = var.ami_id
  instance_type = var.instance_type

  network_interfaces {
    associate_public_ip_address = false
    security_groups            = [var.security_group_id]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo "Environment: ${var.environment}"
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              EOF
  )

  monitoring {
    enabled = true
  }

  tags = var.tags
}

resource "aws_autoscaling_group" "main" {
  name                = "${var.environment}-asg"
  desired_capacity    = var.desired_capacity
  max_size           = var.max_size
  min_size           = var.min_size
  target_group_arns  = var.target_group_arns
  vpc_zone_identifier = var.subnet_ids
  health_check_type  = "ELB"
  
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value              = tag.value
      propagate_at_launch = true
    }
  }
}
