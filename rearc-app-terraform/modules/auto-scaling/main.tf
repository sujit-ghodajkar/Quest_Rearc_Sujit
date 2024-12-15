resource "aws_ecs_service" "rearc_app_service" {
  name            = "rearc-app-service"
  cluster         = module.ecs.cluster_id
  task_definition = module.ecs.task_definition_arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = module.vpc.subnet_ids
    security_groups = [module.alb.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = module.alb.target_group_arn
    container_name   = "rearc-app-container"
    container_port   = 3000
  }

  depends_on = [module.alb.listener_arn]
}

resource "aws_appautoscaling_target" "rearc_app_scaling_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${module.ecs.cluster_name}/${aws_ecs_service.rearc_app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = 2
  max_capacity       = 5
}

resource "aws_appautoscaling_policy" "rearc_app_scaling_policy" {
  name               = "rearc-app-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.rearc_app_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.rearc_app_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.rearc_app_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 300
    scale_out_cooldown = 300
  }
}
