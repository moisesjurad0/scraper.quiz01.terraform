terraform {
  cloud {
    organization = "moisesjurad0"
    workspaces {
      name = "scraper-quiz01-BOT-API"
    }
  }
}

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


data "cloudinit_config" "my_cloud_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    filename     = "cloud.conf"
    content = yamlencode(
      {
        "write_files" : [
          {
            "path" : "/home/ec2-user/docker-compose.yml",
            "content" : file("./cloudinit_config/docker-compose.yml"),
          },
          {
            "path" : "/home/ec2-user/.env",
            "content" : file("./cloudinit_config/.env"),
          },
          {
            "path" : "/home/ec2-user/user-data.sh",
            "content" : file("./cloudinit_config/user-data.sh"),
          },
        ],
      }
    )
  }
  part {
    content_type = "text/x-shellscript"
    content      = file("./cloudinit_config/user-data.sh")
  }
}


# Crear una instancia EC2
resource "aws_instance" "instance" {
  ami           = "ami-04c97e62cb19d53f1"            # Amazon Linux 2023 AMI 2023.2.20231113.0 arm64 HVM kernel-6.1 | 64-bit (Arm)
  instance_type = "t4g.nano"                         # Total Monthly cost: 1.53 USD
  key_name      = aws_key_pair.mi_clave_ssh.key_name # Utiliza la clave importada

  # https://stackoverflow.com/questions/72159273/using-terraform-to-pass-a-file-to-newly-created-ec2-instance-without-sharing-the
  user_data = data.cloudinit_config.my_cloud_config.rendered
  # para mirar que hace esto, checa el archivo user-data.sh

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

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
