# 1- s3 to store state file in secured place 
# resource "aws_s3_bucket" "terraform_state" {
#   bucket = "my-terrform-s3-bucket-2"
#   # lifecycle {
#   #   prevent_destroy = true # to prevent deleting the bucket but can delete ojects inside it 
#   # }
# }


# # 2- enable versioning for state file 
# resource "aws_s3_bucket_versioning" "enabled" {
#     bucket = aws_s3_bucket.terraform_state.id
#     versioning_configuration {
#       status = "Enabled"
#     }
  
# }

# # 3- dynamo db to make lock 
# resource "aws_dynamodb_table" "terraform_lock" {
#     name = "terraform-dynamodb-lock"
#     billing_mode = "PAY_PER_REQUEST"
#     hash_key = "LockID"

#     attribute {
#       name = "LockID"
#       type = "S" #string 
#     }
  
# }


## 2nd 
# terraform {
#   backend "s3" {
#     bucket = "my-terrform-s3-bucket-2"
#     key = "dev/terraform.tfstate"
#     region = "us-east-1"

#     # dynamodb_table = "terraform-dynamodb-lock"
#     # encrypt = true
#    }
#  }

