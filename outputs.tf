output "public_ip" {
  value = aws_instance.instance.public_ip
}

# output "public_ip_summary" {
#   value = "La dirección IP pública de tu instancia EC2 es: ${local.public_ip}"
# }
