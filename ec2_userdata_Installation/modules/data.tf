data "template_file" "init" {
  template = file("${path.module}/install.tpl")
  vars = {
    some_address = "hello"
  }
}