resource "aws_codebuild_source_credential" "public_token_github" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = var.gihub_token
}

resource "aws_codebuild_webhook" "github_webhook" {
  project_name = aws_codebuild_project.pixelapp_proj.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}

resource "aws_codebuild_project" "pixelapp_proj" {
  name           = var.codebuild_project.name
  description    = var.codebuild_project.description
  service_role   = var.codebuild_project.role_arn
  tags           = var.tags_for_app

  artifacts {
    type                = "S3"
    packaging           = "NONE"
    location            = aws_s3_bucket.pixelapp_bucket.bucket
    path                = "/"
    name                = "/"
    encryption_disabled = true
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_APP_REGION"
      type  = "PLAINTEXT"
      value = var.APP_REGION
    }

    environment_variable {
      name  = "APP_NAME"
      type  = "PLAINTEXT"
      value = var.elastic_beanstalk_app.name
    }

    environment_variable {
      name  = "ENV_NAME"
      type  = "PLAINTEXT"
      value = var.elastic_beanstalk_env.name
    }

    environment_variable {
      name  = "ARTIFACT_NAME"
      type  = "PLAINTEXT"
      value = var.codebuild_project.artifact_backend
    }

    environment_variable {
      name  = "AWS_SECRET_KEY"
      type  = "PLAINTEXT"
      value = var.AWS_SECRET_ACCESS_KEY
    }

    environment_variable {
      name  = "AWS_ACCESS_KEY"
      type  = "PLAINTEXT"
      value = var.AWS_ACCSESS_KEY_ID
    }

    environment_variable {
      name  = "FRONTEND_HOST"
      type  = "PLAINTEXT"
      value = "https://${aws_s3_bucket.pixelapp_bucket.website_endpoint}"
    }

    environment_variable {
      name  = "BACKEND_HOST"
      type  = "PLAINTEXT"
      value = "http://${aws_elastic_beanstalk_environment.pixelapp-env-test.cname}"
    }

    environment_variable {
      name  = "BUCKET_NAME"
      type  = "PLAINTEXT"
      value = var.pixelapp_storage.name
    }

    environment_variable {
      name  = "BUCKET_URL_APP"
      type  = "PLAINTEXT"
      value = var.codebuild_project.bucket_url
    }

    environment_variable {
      name  = "BACKEND_PORT"
      type  = "PLAINTEXT"
      value = "80"
    }

    environment_variable {
      name  = "FRONTEND_PORT"
      type  = "PLAINTEXT"
      value = "443"
    }

    environment_variable {
      name  = "DB_NAME"
      type  = "PLAINTEXT"
      value = var.docdb_name
    }

    environment_variable {
      name  = "DB_PASS"
      type  = "PLAINTEXT"
      value = var.docdb_master_password
    }

    environment_variable {
      name  = "DB_ENDPOINT"
      type  = "PLAINTEXT"
      value = aws_docdb_cluster_instance.cluster_instances[0].endpoint
    }

    environment_variable {
      name  = "DB_USER"
      type  = "PLAINTEXT"
      value = var.docdb_master_username
    }
  }
  
  logs_config {
    cloudwatch_logs{
        status = "ENABLED"
    }
  }

  source {
    type            = "GITHUB"
    location        = var.codebuild_project.github_link
    git_clone_depth = 1
  }

  depends_on = [
    aws_docdb_cluster_instance.cluster_instances,
    aws_s3_bucket.pixelapp_storage,
    aws_s3_bucket.pixelapp_bucket,
    aws_elastic_beanstalk_environment.pixelapp-env-test
  ]
}