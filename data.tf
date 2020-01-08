data "aws_ami" "couchdb_ami" {
  name_regex  = "^couchdb-base"
  most_recent = true
  owners      = ["self"]
}
