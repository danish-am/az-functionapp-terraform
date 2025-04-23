# provisioners.tf

resource "null_resource" "zip_function_app" {
  provisioner "local-exec" {
    command = "cd ../function_app_code && zip -r ../terraform/function_app_code.zip HttpTrigger requirements.txt"
  }
}
