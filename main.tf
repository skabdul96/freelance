provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}





#------------------- IAM ----------------
resource "aws_iam_group" "devops_group" {
  name = "jenkins-service-group"
}



resource "aws_iam_policy" "access_policy" {
  name        = "jenkins_policy"
  path        = "/"
  description = "sample policy definition"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "policy-attach" {
  group      = aws_iam_group.devops_group.name
  policy_arn = aws_iam_policy.access_policy.arn
}

resource "aws_iam_role" "s3-access-role" {
  name = "s3_readonly_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "policy-attach" {
  role       = aws_iam_role.s3-access-role.name
  policy_arn = aws_iam_policy.access_policy.arn
}



