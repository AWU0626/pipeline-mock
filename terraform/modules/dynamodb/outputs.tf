// used to created iam for read/write into dynamodb
output "table_arn" {
  value = aws_dynamodb_table.users.arn
}