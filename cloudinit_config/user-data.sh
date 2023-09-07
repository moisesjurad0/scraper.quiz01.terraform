#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user
sudo docker run --env-file .env -d ghcr.io/moisesjurad0/scrapper-1:60 tail -f /dev/null

###
### COMMAND SUMMARY
#1.# sudo docker ps -a
#2.# sudo docker exec -it 00df3100b7fa python main.py <-- PUEDES PROBAR DIRECTAMENTE CON ESTE
#3.# sudo docker exec -it 00df3100b7fa sh <-- O PUEDES INTETAR ESTE PRIMERO Y YA DESDE ADENTRO CORRES PY
###
### COMMAND SUMMARY (utils)
# ls -A
# ls -ltRA
# sudo docker image ls
# sudo docker exec -it <container_name_or_id> <command>
# sudo docker container kill 00df3100b7fa 7bde6dd21cf6 b9c9f804f7d9 48188fbd2fcd
# sudo docker container rm 00df3100b7fa 7bde6dd21cf6 b9c9f804f7d9 48188fbd2fcd
###
### NO SE PUDO INSTALAR
# sudo amazon-linux-extras install docker -y #### NOT WORKIN BECAUSE THIS AMI DOESN'T HAVE amazon-linux-extras
