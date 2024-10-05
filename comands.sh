!/bin/bash
sudo yum update -y

# Instalar Docker (Amazon Linux 2 usa yum)
sudo amazon-linux-extras install docker -y

# Iniciar Docker
sudo systemctl start docker

# Habilitar Docker para que se inicie al arrancar el sistema
sudo systemctl enable docker

# Añadir el usuario 'ec2-user' al grupo docker para poder ejecutar Docker sin sudo
sudo usermod -aG docker ec2-user

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Dar permisos de ejecución a Docker Compose
sudo chmod +x /usr/local/bin/docker-compose

# Descargar la imagen de Docker que necesitas (por ejemplo, la imagen de Nginx)
sudo docker pull nginx:latest

# Opcional: Ejecutar un contenedor con la imagen descargada (en este caso, Nginx)
sudo docker run -d -p 80:80 --name my_nginx_container nginx:latest

# Verificar que Docker y Docker Compose se instalaron correctamente
docker --version
docker-compose --version

# Verificar que la imagen se ha descargado correctamente
sudo docker images

 