# --------------------------------------
# AWS Backend configuration
# --------------------------------------
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      region = "us-east-1"
    }
  }
}

# --------------------------------------
# AWS Provider
# --------------------------------------
provider "aws" {
  region = "us-east-1"
}



# --------------------------------------
# IAM - Create policy
# --------------------------------------
resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  path        = "/"
  description = "" # empty at the moment

  policy = file("./policy.json")
}


# --------------------------------------
# IAM - Create group
# --------------------------------------
resource "aws_iam_group" "group" {
  name = var.group_name
  path = "/"
}

# --------------------------------------
# IAM - Attach policy to group
# --------------------------------------
resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.group.name
  policy_arn = aws_iam_policy.policy.arn
}

# --------------------------------------
# IAM - Create new IAM user
# --------------------------------------
resource "aws_iam_user" "user" {
  name = var.user_name
  path = "/"
}

# --------------------------------------
# IAM - Attach user to group
# --------------------------------------
resource "aws_iam_user_group_membership" "group_membership_user" {
  user = aws_iam_user.user.name

  groups = [
    aws_iam_group.group.name
  ]
}
