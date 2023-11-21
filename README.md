# scraper.quiz01.terraform

Para obtener las `access_key` y `secret_key` de AWS, y la clave pública `tu-llave-ssh.pub` debes seguir estos pasos

## Steps

### 1. Crear una clave SSH (si aún no tienes una)

Si ya tienes una clave SSH que deseas usar, puedes omitir este paso. De lo contrario, aquí te muestro cómo crear una nueva clave SSH:

```bash
ssh-keygen -t rsa -b 2048 -f tu-llave-ssh
```

Este comando generará una nueva clave SSH en los archivos `tu-llave-ssh` y `tu-llave-ssh.pub`.

### 2. Crear una cuenta de AWS o usar una existente

Si aún no tienes una cuenta de AWS, puedes crear una en el sitio web de AWS (<https://aws.amazon.com/>). Si ya tienes una cuenta, puedes usarla para obtener tus credenciales de acceso.

### 3. Obtener las credenciales de AWS

Para obtener las credenciales de AWS (las `access_key` y `secret_key`), sigue estos pasos:

1. a. Inicia sesión en la Consola de AWS utilizando tu cuenta de AWS.
1. En la esquina superior derecha, haz clic en tu nombre de usuario y selecciona "My Security Credentials" (Mis credenciales de seguridad).
1. En la sección "Access keys" (Claves de acceso), verás una lista de tus claves de acceso existentes (si las tienes) o la opción para crear una nueva clave de acceso. Si aún no tienes una clave de acceso, puedes crear una nueva.
1. Haz clic en "Create New Access Key" (Crear nueva clave de acceso).
1. Se te mostrará la `access_key` y la `secret_key`. Guarda estas claves en un lugar seguro, ya que no podrás ver la `secret_key` nuevamente después de este paso.

### 4. Configurar Terraform

1. escribe las `access_key` y `secret_key`
1. escribe el path del archivo con la ssh_key

### 5. SSH connect

```sh
ssh -i tu-llave-ssh.pem ec2-user@<IP-PUBLICA-DE-TU-EC2>
# ssh -i .\.ssh_key\tu-llave-ssh ec2-user@54.86.219.204
# ssh -i .\.ssh_key\tu-llave-ssh ec2-user@54.89.94.185
# ssh -i .\.ssh_key\tu-llave-ssh ec2-user@54.146.1.110
# ssh -i .\.ssh_key\tu-llave-ssh ec2-user@3.91.229.161
# ssh -i .\.ssh_key\tu-llave-ssh ec2-user@52.90.142.186
# ssh -i .\.ssh_key\tu-llave-ssh ec2-user@54.209.232.155
# ssh -i .\.ssh_key\tu-llave-ssh ec2-user@54.159.162.11
ssh -i .\.ssh_key\tu-llave-ssh ec2-user@44.221.44.105
```

```sh
The authenticity of host '54.210.221.51 (54.210.221.51)' can't be established.
ED25519 key fingerprint is SHA256:*******************************************.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? YES
Warning: Permanently added '54.210.221.51' (ED25519) to the list of known hosts.
   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'
[ec2-user@ip-172-31-42-1 ~]$  
```

### 6. Obtener IP publico EC2

Para obtener el ip, deberás configurar una variable output, luego ejecutar apply

```sh
# 1. configura variable ouput

# 2. ejecuta apply
terraform apply

# 3. posteriormente la puedes obtener con "terraform output <nombre de la variable>"
terraform output public_ip
```
