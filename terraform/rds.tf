resource "aws_db_subnet_group" "main" {

  name = "employee-db-subnet-group"

  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]

  tags = {
    Name = "employee-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {

  identifier = "employee-postgres"

  engine = "postgres"

  engine_version = "16"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  db_name = "employee_db"

  username = "postgres"

  password = "Employee123"

  publicly_accessible = false

  skip_final_snapshot = true

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  tags = {
    Name = "Employee PostgreSQL"
  }

}