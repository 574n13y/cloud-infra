resource "aws_security_group" "main" {
  name        = "${var.environment}-sg"
  description = "Main security group"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.environment}-sg"
  })
}

resource "aws_kms_key" "main" {
  description             = "KMS key for encryption"
  deletion_window_in_days = 7
  enable_key_rotation    = true

  tags = merge(var.tags, {
    Name = "${var.environment}-kms"
  })
}
