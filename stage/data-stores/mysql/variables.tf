variable "user" {
    description = "The username for the database"
    type = string
    sensitive = true
}

variable "pass" {
    description = "The password for the database"
    type = string
    sensitive = true
}