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

  provisioner "file" {
    content     = file("./.env")
    destination = "/home/ec2-user/.env"
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.ssh_file_priv)
      host        = self.public_ip
    }
  }



  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -a -G docker ec2-user
              sudo docker run -d ghcr.io/moisesjurad0/scrapper-1:60 tail -f /dev/null --env-file .env
              EOF
  ###
  ### NO SE PUDO INSTALAR 
  # sudo amazon-linux-extras install docker -y #### NOT WORKIN BECAUSE THIS AMI DOESN'T HAVE amazon-linux-extras
  ###
  ### COMMANDS 
  # sudo docker image ls
  # sudo docker ps -a
  # sudo docker container rm d3b809e6e9e7 99b3e502514d dfb8c3d950cf 5318d8331fe4 da0a45b39dbf 
  # sudo docker exec -it CONTAINER_ID_OR_NAME sh
  # sudo docker exec -it 45a279803fb1 sh
  # sudo docker run -d ghcr.io/moisesjurad0/scrapper-1:60 tail -f /dev/null --env-file .env



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
