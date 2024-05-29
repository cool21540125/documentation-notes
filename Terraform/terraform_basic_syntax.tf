
### 
variable "demo_var" {
  type        = string
  description = "description"
  default     = "default"
  validation {
    condition     = var.max_size < 16
    error_message = "must < 16 words"
  }
}

###
variable "map_example" {
  description = "map example"
  type        = map(string)

  default = {
    key1 = "value1"
    key2 = "value2"
  }
}

### 
variable "object_example01" {
  type = object({
    name = string
    age  = number
    jobs = list(string)
    book = map(string)
  })
  default = {
    name = "Tony"
    age  = 18
    jobs = ["job1", "job2"]
    book = {
      publish = "not yet"
      name    = "I'm thinking"
    }
  }
}
