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
