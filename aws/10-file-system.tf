
/*
resource "aws_security_group" "main" {
  name        = "security-group"
  description = "security-group"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "main" {
  security_group_id = aws_security_group.main.id

  cidr_ipv4   = "10.0.0.0/16"
  from_port   = 2049
  ip_protocol = "tcp"
  to_port     = 2049
}

resource "aws_efs_file_system" "foo" {
  creation_token = "file_system"
  performance_mode = "generalPurpose"
  encrypted = true
  tags = {
    Name = "MyEFSFileSystem"
  }
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      = aws_subnet.private-us-east-1a.id
  security_groups = [aws_security_group.main.id]
}

resource "aws_efs_mount_target" "betha" {
  file_system_id = aws_efs_file_system.foo.id
  subnet_id      = aws_subnet.private-us-east-1b.id
  security_groups = [aws_security_group.main.id]
}

resource "aws_efs_access_point" "test" {
  file_system_id = aws_efs_file_system.foo.id
  posix_user  {
              gid = 1000 # for amundsen, important that same gui/uid used across each access point
              uid = 1000
            }

  root_directory { 
    path= "/jenkins"
      creation_info{
        owner_uid=1000
      owner_gid=1000
      permissions=777 
      }
  }
}
*/

resource "aws_iam_policy" "eks_worknode_ebs_policy" {
  name = "Amazon_EBS_CSI_Driver"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateSnapshot",
        "ec2:CreateTags",
        "ec2:CreateVolume",
        "ec2:DeleteSnapshot",
        "ec2:DeleteTags",
        "ec2:DeleteVolume",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:DescribeAvailabilityZones"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}
# And attach the new policy
resource "aws_iam_role_policy_attachment" "worknode-AmazonEBSCSIDriver" {
  policy_arn = aws_iam_policy.eks_worknode_ebs_policy.arn
  role       = aws_iam_role.nodes.name
}

/*

resource "aws_iam_policy" "eks_worknode_elastic_policy" {
  name = "Amazon_elastic"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "elasticfilesystem:DescribeAccessPoints",
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}


resource "aws_iam_role_policy_attachment" "worknode-AmazonElastic" {
  policy_arn = aws_iam_policy.eks_worknode_elastic_policy.arn
  role       = aws_iam_role.nodes.name
}

*/