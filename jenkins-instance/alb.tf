variable "aws_region" {
  default = "ap-northeast-2"
  type = string 
}
variable "target_port" {
  type        = number
  description = "The port will use for HTTP 8080 requests"
  default     = 8080
}
variable "http_port" {
  type        = number
  description = "The port will use for HTTP 80 requests"
  default     = 80
}

// alb
resource "aws_security_group" "project02-alb-sg" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  name = "project02-alb-sg"
  
  ingress { //HTTP
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks =  ["0.0.0.0/0"]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "project02-alb-sg"
  }
}

#로드밸런스 그룹
resource "aws_lb" "example" {
  name               = "project02-alb"
  load_balancer_type = "application"
  subnets            = [data.terraform_remote_state.vpc.outputs.public-subnet-2a-id,data.terraform_remote_state.vpc.outputs.public-subnet-2c-id]
  security_groups    = [aws_security_group.project02-alb-sg.id]

}

//로드밸런스 리스너-jenkins
resource "aws_lb_listener" "jenkins_http" {
  load_balancer_arn = aws_lb.example.arn
  #arn을 통해 해당 lb리스너가 어떤 lb그룹의 규칙인지 연결,참조 시킴
  port     = 80
  protocol = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

//로드밸런스 리스너 룰-jenkins
resource "aws_lb_listener_rule" "jenkins" {
  listener_arn = aws_lb_listener.jenkins_http.arn
  priority     = 100

  action { 
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }

  condition {
    host_header {
      values = ["project02-jenkins.busanit-lab.com"]
    }
  }
}


//리스너 룰 대상그룹-jenkins EC2
resource "aws_lb_target_group" "jenkins" {
  name     = "project02-jenkins-tg"
  target_type = "instance"
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


//로드밸런스 리스너 룰-eks
resource "aws_lb_listener_rule" "eks" {
  listener_arn = aws_lb_listener.jenkins_http.arn
  priority     = 99 #jenkins가 100

  action { 
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks.arn
  }

  condition {
    host_header {
      values = ["project02-eks.busanit-lab.com"] #여기 들어오는 모든 것들
    }
  }

}
//리스너 룰 대상그룹-eks
resource "aws_lb_target_group" "eks" {
  name     = "project02-eks-tg"
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2

  }
}


//로드밸런스 리스너 룰-grafana
resource "aws_lb_listener_rule" "grafana" {
  listener_arn = aws_lb_listener.jenkins_http.arn
  priority     = 97 #jenkins가 100

  action { 
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }

  condition {
    host_header {
      values = ["project02-grafana.busanit-lab.com"] #여기 들어오는 모든 것들
    }
  }

}
//리스너 룰 대상그룹-grafana
resource "aws_lb_target_group" "grafana" {
  name     = "project02-grafana-tg"
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2

  }
}




output "alb_dns_name" {
    value = aws_lb.example.dns_name
    description = "The domain name of the load balance"
}


resource "aws_lb_target_group_attachment" "jenkins" {
  target_group_arn = aws_lb_target_group.jenkins.arn
  target_id = aws_instance.jenkins.id
  port = "8080"
}