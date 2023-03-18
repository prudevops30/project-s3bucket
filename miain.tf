#1.create s3 bucket
resource "aws_s3_bucket" "env_s3-dev" {
  bucket = "bootcamp30-${random_integer.bucket_name.result}-${var.name}"
}

/* tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
*/

#2. Bucket ACl
resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.env_s3-dev.id
  acl    = var.acl
}

#3. Bucket versioning "
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.env_s3-dev.id
  versioning_configuration {
    status = var.versioning
  }
}

#4. Bucket encryptiond
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.env_s3-dev.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.prudevops30key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

#5. kms for Bucket encryptiondata "
resource "aws_kms_key" "prudevops30key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

#6. Random integer
resource "random_integer" "bucket_name" {
  min = 1
  max = 99
  keepers = {
    # Generate a new integer each time we switch to a new listener ARN
    bucket_name = var.name
  }
}