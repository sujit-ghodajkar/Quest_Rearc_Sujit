resource "aws_ecs_cluster" "rearc_app_cluster" {
  name = "rearc-app-cluster"
}

resource "aws_iam_role" "rearc_app_task_execution_role" {
  name = "rearc-app-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "rearc_app_task_execution_role_policy" {
  name       = "rearc-app-task-execution-role-policy"
  roles      = [aws_iam_role.rearc_app_task_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "rearc_app_task" {
  family                   = "rearc-app-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.rearc_app_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "rearc-app-container"
    image     = "public.ecr.aws/my-docker-hub-repo/my-app:latest"
    essential = true
    portMappings = [
      {
        containerPort = 3000
        protocol      = "tcp"
      }
    ]
  }])
}
