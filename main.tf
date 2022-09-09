provider "aws" {
  region = "eu-central-1"
}


resource "aws_s3_bucket" "b" {
  bucket = "bruno-wordpress"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}


resource "aws_key_pair" "deployer" {
  key_name   = "key-local"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1B0o0/U/3QYIi+suXWIBvahTZcSDuF6EBCmII34zYVV4kgIuT5Qa/DcfF9Gu+AzCTJhMAUnhOeLfM8HCi77ch5y/QZpday0cWRPwpPX6cwVVTQ4x9jFu1Od8Rjd2y8q/rJ204tBjpr7i/R04/Xg/+NXc3UFSOjTjqjv9O4u61G0tsZk+HbR0iLa/7rQmb1eVPjj1qEpzPFNchyBUPF7NxJkHbim430JbPSXM630sQXoWbOxttOHXYnKCqR4vmpOfAzAr9nb9+iBbOdb8rASyU9tdGau46kYS9aq0EKjUWtfKvTHq6LnRmw2N+V5/vgA4zNi643AVgN2BfMKe0kXvsk7RV7G2ccOzFo3SyPTBKClLx4rDx3FMwlPfgbtrR6ZvXB18crYNAduxX95CZpsM3U/v16NcMbKZTimmQVlTtRRu4xa7XKk1rOeLfEJ3HCWYn4hs29Dg0ZxHasG6oG/YohDEEe6vNxQb13PiBmwBONe9fPNKmJ1rubBbYmkSzdN0= ubuntu@LWO1-LDL-A12972"
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.aws-linux-sg.id]
  associate_public_ip_address = var.linux_associate_public_ip_address
  key_name = aws_key_pair.deployer.key_name
  iam_instance_profile = "s3fs"


}



output  "public_ip" {
  description = "Value of the Name tag for the EC2 instance"
  value = [aws_instance.web.public_ip]
  }
