[
    {
        "name": "${name}",
        "image": "${repository_url}",
        "cpu": 256,
        "memory": 512,
        "portMappings": ${port_mappings},
        "essential": true,
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "/ecs/${name}-deploy",
                "mode": "non-blocking",
                "max-buffer-size": "25m",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "ecs"
            }
        }
    }
]