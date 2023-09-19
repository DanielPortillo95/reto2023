provider "aws" {
  region = "us-east-1" 

resource "aws_instance" "example_instance" {
  ami           = "ami-0c55b159cbfafe1f0" 
  instance_type = "t3a.micro"

  associate_public_ip_address = true

  root_block_device {
    volume_size = 30
  }
}

resource "aws_eip" "example_eip" {
  instance = aws_instance.example_instance.id
}

resource "aws_lb" "example_alb" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  enable_deletion_protection = false

  subnets = [aws_subnet.example_subnet.id] # Ajusta según tus subnets

  enable_http2 = true # Habilita HTTP/2 en el ALB
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.example_alb.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type = "fixed-response"
    
    fixed_response {
      content_type = "text/plain"
      status_code  = "301"
      status_code_fixed = "HTTP_301"
      message_body = "Redirecting to HTTPS"
    }
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.example_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08" # Cambia según tus necesidades

}

# Configura las reglas del listener HTTP para limitar por IP y método (POST)
resource "aws_lb_listener_rule" "ip_rule" {
  listener_arn = aws_lb_listener.http_listener.arn

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "403"
      message_body = "Access Denied"
    }
  }

  condition {
    path_pattern {
      values = ["/restricted-path"]
    }

    source_ip {
      values = ["x.x.x.x/x"] # Cambia a las IP permitidas
    }

    http_request_method {
      values = ["POST"]
    }
  }
}

resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Security group for example instance"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


