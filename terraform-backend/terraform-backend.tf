resource "aws_s3_bucket" "project02-s3-tf-state" {

  bucket = "project02-s3-tf-state"

  tags = {
    "Name" = "project02-s3-tf-state"
  }
  
}

resource "aws_dynamodb_table" "project02-lock-table" {

  depends_on   = [aws_s3_bucket.project02-s3-tf-state]
  name         = "project02-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    "Name" = "project02-lock-table"
  }

}