# Configuración de las credenciales de AWS
provider "aws" {
  region     = "us-east-1" # Cambia a tu región preferida
  access_key = var.access_key
  secret_key = var.secret_access_key
}

# Importar la clave SSH a AWS
resource "aws_key_pair" "mi_clave_ssh" {
  key_name   = "tu-llave-ssh"     # Nombre que deseas darle a la clave en AWS
  public_key = file(var.ssh_file) # Ruta de la clave pública
}

# Crear una instancia EC2
resource "aws_instance" "instance" {
  ami           = "ami-051f7e7f6c2f40dc1"            # Amazon Linux 2023 AMI (Free tier eligible)
  instance_type = "t2.micro"                         # Tipo de instancia gratuito
  key_name      = aws_key_pair.mi_clave_ssh.key_name # Utiliza la clave importada

  user_data = <<-EOF
              #!/bin/bash
              docker run -d ghcr.io/moisesjurad0/scrapper-1:60
              EOF

  tags = {
    Name = "mi-instancia-ec2"
  }
}

# Configurar una regla de seguridad para permitir el tráfico SSH
resource "aws_security_group" "sg" {
  name        = "allow-ssh-and-http"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# https://registry.terraform.io/providers/babylonhealth/aws-babylon/latest/docs/resources/network_interface_sg_attachment
resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.sg.id
  network_interface_id = aws_instance.instance.primary_network_interface_id
}
