
### 建立 "tony.0", "tony.1", "tony.2"
resource "aws_iam_user" "example_users" {
  count = 3
  name  = "user.${count.index}"
}

