# configure dynamodb table key
resource "aws_dynamodb_table" "users" {
  name = "Users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "username"

  # only need to add key attribute for dynamodb
  attribute {
    name = "username"
    type = "S"
  }
}