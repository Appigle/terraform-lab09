resource "aws_s3_bucket" "web_bucket" {
  bucket        = "prog8830-week-10"
  force_destroy = true

  tags = {
    Name = "PROP8830-GROUP1-LAB08"
  }
}

resource "aws_s3_bucket_versioning" "web_bucket_versioning" {
  bucket = aws_s3_bucket.web_bucket.id

  versioning_configuration {
    status = "Disabled"
  }
}

locals {
  s3_objects = {
    htmlfile = {
      key    = "/webcontent/index.html"
      source = "./webcontent/index.html"
    }
    stylesheet = {
      key    = "/webcontent/styles.css"
      source = "./webcontent/styles.css"
    }
    programsimg = {
      key    = "/webcontent/programs.jpg"
      source = "./webcontent/programs.jpg"
    }
    studentsimg = {
      key    = "/webcontent/students.jpg"
      source = "./webcontent/students.jpg"
    }
    campusimg = {
      key    = "/webcontent/campus.jpg"
      source = "./webcontent/campus.jpg"
    }
  }
}

resource "aws_s3_object" "webcontent" {
  for_each = local.s3_objects

  bucket = aws_s3_bucket.web_bucket.bucket
  key    = each.value.key
  source = each.value.source

  tags = {
    Name = "PROP8830-GROUP1-LAB08"
  }
}
