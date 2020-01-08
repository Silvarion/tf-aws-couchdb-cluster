################################
##
##  Security Groups for CouchDB Cluster
##
###############################

## Resources ##
resource "aws_security_group" "couchdb-sg" {
  name          = "${var.environment}-couchdb-sg"
  vpc_id        = var.vpc
  tags          = {
    Name        = "${var.environment}-couchdb-sg"
    Owner       = var.owner
    Environment = var.environment
  }

  ## SSH
  ingress {
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.cidr_blocks
    protocol    = "tcp"
  }

  ## CouchDB Internode Port
  ingress {
    from_port   = 4369
    to_port     = 4369
    cidr_blocks = var.cidr_blocks
    protocol    = "tcp"
  }

  ## CouchDB Default Port
  ingress {
    from_port   = 5984
    to_port     = 5984
    cidr_blocks = var.cidr_blocks
    protocol    = "tcp"
  }

  ## CouchDB Admin Default Port
  ingress {
    from_port   = 5986
    to_port     = 5986
    cidr_blocks = var.cidr_blocks
    protocol    = "tcp"
  }

  ## CouchDB Internode Port
  egress {
    from_port   = 4369
    to_port     = 4369
    cidr_blocks = var.cidr_blocks
    protocol    = "tcp"
  }

  ## CouchDB Default Port
  egress {
    from_port   = 5684
    to_port     = 5684
    cidr_blocks = var.cidr_blocks
    protocol    = "tcp"
  }

  ## CouchDB Admin Default Port
  egress {
    from_port   = 5686
    to_port     = 5686
    cidr_blocks = var.cidr_blocks
    protocol    = "tcp"
  }
}

################################
##
##  CouchDB Cluster Load Balancer
##
###############################

resource "aws_lb" "couchdb-lb" {
  name = "${var.environment}-couchdb-lb"

  #  security_groups                   = ["${var.security_groups}"]
  subnets                          = var.subnets
  enable_cross_zone_load_balancing = true
  internal                         = true
  load_balancer_type               = "application"
  security_groups                  = var.security_groups
  tags = {
    Name        = "${var.environment}-couchdb-lb"
    Owner       = var.owner
    Environment = var.environment
    Service     = "couchdb"
  }
}

resource "aws_lb_target_group" "couchdb-lb-tg" {
  name     = "${var.environment}-couchdb-lb-tg"
  protocol = "HTTP"
  port     = 5984
  vpc_id   = var.vpc_id
  tags = {
    Name        = "${var.environment}-couchdb-lb-tg"
    Owner       = var.owner
    Environment = var.environment
    Service     = "couchdb"
  }
}

resource "aws_lb_listener" "couchdb-lb-lsnr-5984" {
  load_balancer_arn = aws_lb.couchdb-lb.arn
  protocol          = "HTTP"
  port              = 5984
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.couchdb-lb-tg.arn
  }
}

resource "aws_lb_listener" "couchdb-lb-lsnr-5986" {
  load_balancer_arn = aws_lb.couchdb-lb.arn
  protocol          = "HTTP"
  port              = 5986
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.couchdb-lb-tg.arn
  }
}

################################
##
##  CouchDB Cluster Autoscaling Group
##
###############################



resource "aws_launch_template" "couchdb-lt" {
  name                   = "${var.environment}-couchdb-node-lt"
  image_id               = data.aws_ami.couchdb-ami.id
  instance_type          = var.node-size
  key_name               = var.key_name
  # user_data              = base64encode(data.template_file.config.rendered)
  vpc_security_group_ids = [ aws_security_group.couchdb-sg.id ]
  iam_instance_profile {
    name = "${var.environment}-couchdb-iam-profile"
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_type           = "gp2"
      volume_size           = var.root-ebs-size
      delete_on_termination = true
    }
  }
  block_device_mappings {
    device_name = "/dev/xvde"
    ebs {
      volume_type           = "gp2"
      volume_size           = var.data-ebs-size
      delete_on_termination = true
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.environment}-couchdb-node"
      Environment = var.environment
      Owner       = var.owner
    }
  }
  tags = {
    Name        = "${var.environment}-es-data-node-lt"
    Environment = var.environment
    Owner       = "upc"
  }
}

resource "aws_autoscaling_group" "couchdb-asg" {

  
}
