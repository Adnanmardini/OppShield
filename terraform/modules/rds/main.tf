#.......RDS subnet group........
resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name        = "${var.project}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

#.......RDS security group........
resource "aws_security_group" "rds" {
  name        = "${var.project}-${var.environment}-rds-sg"
  description = "Allow inbound DB traffic only from app layer"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Postgres from app layer only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project}-${var.environment}-rds-sg"
    Environment = var.environment
  }
}
#..........RDS instance........
resource "aws_db_instance" "main" {
  identifier     = "${var.project}-${var.environment}-db"
  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.master_username

  #creates cloudwatch group automatically, rds handles this natively
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  # AWS creates and manages the master password automatically in
  # Secrets Manager - we never see or set the password ourselves.
  manage_master_user_password = true

  db_subnet_group_name  = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Private subnet only - task requirement
  publicly_accessible = false

  multi_az = var.multi_az

  backup_retention_period = var.backup_retention_days
  backup_window            = "03:00-04:00"
  maintenance_window       = "mon:04:30-mon:05:30"

  skip_final_snapshot       = var.environment != "prod"
  final_snapshot_identifier = var.environment == "prod" ? "${var.project}-${var.environment}-final-snapshot" : null
  deletion_protection       = var.environment == "prod"

  tags = {
    Name        = "${var.project}-${var.environment}-db"
    Environment = var.environment
  }
}