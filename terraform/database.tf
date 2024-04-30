# Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
    name       = "${var.vpc_name}-subnet-group"
    subnet_ids = aws_subnet.public_subnets[*].id

    tags = var.common_tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_tcp" {
    security_group_id = aws_security_group.allow_tcp.id
    from_port         = 5432
    to_port           = 5432
    ip_protocol       = "tcp"
    cidr_ipv4         = "0.0.0.0/0"
}
  
resource "aws_vpc_security_group_egress_rule" "allow_tcp" {
    security_group_id = aws_security_group.allow_tcp.id
    from_port         = 5432
    to_port           = 5432
    ip_protocol       = "tcp"
    cidr_ipv4         = "0.0.0.0/0"
}

#########################################
# DATABASE
#########################################
# RDS Database
resource "aws_db_instance" "virtual_spider_zoo_db" {
    identifier                  = var.db_name
    username                    = var.db_username
    allocated_storage           = 20
    storage_type                = "gp2"
    engine                      = "postgres"
    engine_version              = "16.1"
    instance_class              = "db.t3.micro"
    db_subnet_group_name        = aws_db_subnet_group.db_subnet_group.name
    vpc_security_group_ids      = [aws_security_group.allow_tcp.id]
    maintenance_window          = "Mon:00:00-Mon:01:00"
    publicly_accessible         = true
    skip_final_snapshot         = true
    apply_immediately           = true
    copy_tags_to_snapshot       = true
    manage_master_user_password = true
    multi_az                    = false

    tags = var.common_tags
}
