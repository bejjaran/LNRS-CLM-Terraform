###################
# Security Groups #
###################
# Web ALB
resource "aws_security_group" "web-lb" {

  name        = "${var.tag_application_short}-${var.environment_short}-web-lb"
  description = title("${var.environment} LNRS Web ALB Rules")
  vpc_id      = data.aws_vpc.selected.id
  tags        = merge(map("Name", "${var.tag_application_short}-${var.environment_short}-web-lb"), local.default_tags)

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "HTTP Inbound"
  } 

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    description = "HTTPS Inbound"
  }  

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["83.231.190.26/32", "209.243.55.105/32", "66.241.32.168/31", "209.243.55.98/32", "209.243.55.101/32", "209.243.54.78/32"]
    description = "HTTPS Internal NATs Inbound"
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["212.38.169.106/32", "37.220.21.50/32", "77.240.14.105/32", "62.128.207.214/32", "217.194.217.82/32", "78.129.191.59/32", "78.129.191.58/32"]
    description = "HTTPS External Monitoring Inbound"
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["54.244.52.192/26", "54.241.32.64/26", "54.245.168.0/26", "54.183.255.128/26", "15.177.0.0/18", "107.23.255.0/26", "54.243.31.192/26"]
    description = "HTTPS External Monitoring Inbound (AWS R53 Health Checks US and Global)"
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    #cidr_blocks = ["${data.aws_subnet.subnets["dmz"].cidr_block}"]
    #cidr_blocks = ["10.22.96.0/26", "10.22.96.64/26", "10.22.96.128/26"]
    cidr_blocks = var.aws_public_subnet_cidr

    description = "Public Subnet - HTTPS Outbound"
  }

}

# Web
resource "aws_security_group" "web" {

  name        = "${var.tag_application_short}-${var.environment_short}-web"
  description = title("${var.environment} LNRS Web Rules")
  vpc_id      = data.aws_vpc.selected.id
  tags        = merge(map("Name", "${var.tag_application_short}-${var.environment_short}-web"), local.default_tags)
  
  # Internal Network
  ingress {
    from_port   = "3389"
    to_port     = "3389"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    description = "TEMP - Remove me after inital tests"
  }

  ingress {
    from_port       = "443"
    to_port         = "443"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web-lb.id}"]
    description     = "HTTPS Inbound"
  }  

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    description = "Internal - HTTPS Inbound"
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Outbound"
  }

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS Outbound"
  }

  egress {
    from_port       = "1433"
    to_port         = "1433"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.db.id}"]
    description     = "MSSQL Outbound"
  }
  
  egress {
    from_port   = "8200"
    to_port     = "8200"
    protocol    = "tcp"
    cidr_blocks = ["10.245.206.0/24"]
    description = "Vault Outbound"
  }

  egress {
    from_port   = "53"
    to_port     = "53"
    protocol    = "UDP"
    cidr_blocks = ["10.245.5.11/32", "10.245.6.11/32", "10.193.25.35/32"]
    description = "DNS Outbound"
  }

  egress {
    from_port   = "25"
    to_port     = "25"
    protocol    = "TCP"
    cidr_blocks = ["10.0.0.0/8"]
    description = "SMTP Outbound"
  }

  egress {
    from_port   = "5062"
    to_port     = "5062"
    protocol    = "TCP"
    cidr_blocks = ["10.240.38.33/32", "10.240.62.173/32"]
    description = "TEMP - Logstash Staging Outbound"
  }

  egress {
    from_port   = "9200"
    to_port     = "9200"
    protocol    = "TCP"
    cidr_blocks = ["10.240.62.172/32", "10.240.62.173/32", "10.240.62.174/32"]
    description = "TEMP - Elasticsearch Staging Outbound"
  }

  egress {
    from_port   = "5062"
    to_port     = "5062"
    protocol    = "TCP"
    cidr_blocks = ["10.246.28.121/32"]
    description = "Logstash Outbound - Boca VIP"
  }

    egress {
    from_port   = "5062"
    to_port     = "5062"
    protocol    = "TCP"
    cidr_blocks = ["10.247.31.174/32"]
    description = "Logstash Outbound - Alpharetta VIP"
  }

    egress {
    from_port   = "9200"
    to_port     = "9200"
    protocol    = "TCP"
    cidr_blocks = ["10.246.28.123/32"]
    description = "Elasticsearch Outbound - Boca VIP"
  }

  depends_on = [aws_security_group.web-lb, aws_security_group.db]

}

# DB
resource "aws_security_group" "db" {

  name        = "${var.tag_application_short}-${var.environment_short}-db"
  description = title("${var.environment} LNRS Database Rules")
  vpc_id      = data.aws_vpc.selected.id
  tags        = merge(map("Name", "${var.tag_application_short}-${var.environment_short}-db-lb"), local.default_tags)

  # Internal Network
  ingress {
    from_port   = "1433"
    to_port     = "1433"
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    description = "TEMP - Remove me after inital tests"
  }

  # Egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Seperate so App & DB can reference eachother
resource "aws_security_group_rule" "db" {
  type                     = "ingress"
  from_port                = 1433
  to_port                  = 1433
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.web.id
  security_group_id        = aws_security_group.db.id
}