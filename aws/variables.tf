variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "AWS Access Key"
}
variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "AWS Secret Access Key"
}
variable "AWS_REGION" {
  type        = string
  description = "AWS Resources Region"
}
variable "AWS_SSH_KEY_NAME" {
  type        = string
  description = "SSH key for EC2"
}
variable "RDS_USERNAME" {
  type        = string
  description = "Username for RDS DB"
}
variable "RDS_PASSWORD" {
  type        = string
  description = "Password for RDS DB"
}
