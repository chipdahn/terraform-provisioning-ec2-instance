provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "web" {
  ami           = "ami-0d70546e43a941d70"
  instance_type = "t2.micro"

  tags = {
    Name = "webServer"
  }
}

resource "aws_s3_bucket" "webServer" {
  bucket = "blog-site"
  policy = file("policy.json")
}

resource "aws_s3_bucket_website_configuration" "webServer" {
  bucket = aws_s3_bucket.webServer.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}

resource "aws_s3_bucket_acl" "web_blog" {
  bucket = aws_s3_bucket.webServer.id
  acl    = "public-read"
}

module "policy" {
  source = "./policy"
}
