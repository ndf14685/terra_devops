resource "aws_ecr_repository" "docker-internal-repository" {
  name                 = "docker-internal-repo"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "docker-internal-repo-policy" {
  repository = aws_ecr_repository.docker-internal-repository.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "adds full ecr access to the docker internal repository",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetLifecyclePolicy",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
      }
    ]
  }
  EOF
}
