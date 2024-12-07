variable "name_prefix" {
 description = "Name prefix for application"
 type        = string
 default     = "chichao-bookinventory"
}

variable "data1_prefix" {
    description = "Data 1 prefix for application"
    type =  string
    default = "ISBN"
}

variable "data2_prefix" {
    description = "Data 1 prefix for application"
    type =  string
    default = "Genre"
}

variable "hash_key" {
    description = "Hash key for application"
    type = string
    default = "ISBN"
}

variable "range_key" {
    description = "range key for application"
    type = string
    default = "Genre"
}

variable "pay_per_request" {
     description = "pay_per_request"
    type = string
    default = "PAY_PER_REQUEST"
}

# Replace with your table's actual ARN
variable "dynamodb_table_arn" {
  default = "arn:aws:dynamodb:ap-southeast-1:255945442255:table/chichao-bookinventory"
}
