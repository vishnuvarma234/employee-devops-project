resource "aws_ecs_cluster" "main" {
  name = "employee-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "employee-cluster"
  }
}

resource "aws_ecs_task_definition" "employee_app" {
  family                   = "employee-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "employee-app"
      image     = aws_ecr_repository.employee_app.repository_url
      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Name = "employee-task-definition"
  }
}

resource "aws_ecs_service" "employee_service" {
  name            = "employee-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.employee_app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  depends_on = [
    aws_lb_listener.http
  ]

  network_configuration {
    assign_public_ip = true

    subnets = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]

    security_groups = [
      aws_security_group.ecs_sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs.arn
    container_name   = "employee-app"
    container_port   = 5000
  }

  tags = {
    Name = "employee-ecs-service"
  }
}