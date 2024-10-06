#!/bin/bash
# Actualizamos el sistema actual e instalamos los requisitos
sudo yum update -y

# Instalamos Docker en la instancia
sudo yum install docker -y

# Iniciamos Docker dentro de la instancia
sudo systemctl start docker 

# Agregamos el usuario ec2-user al grupo docker para ejecutar sin sudo
sudo usermod -a -G docker ec2-user

# Habilitamos Docker para iniciar con el sistema
sudo systemctl enable docker

# Descargamos e iniciamos el contenedor de Nginx
sudo docker run -d -p 80:80 --name nginx-container nginx

# Cambiar el contenido de la página de bienvenida de Nginx usando sed
sudo docker exec nginx-container sed -i 's|Welcome to nginx!|CLOUD2 LIZETH ESTRADA|g; s|If you see this page, the nginx web server is successfully installed and working. Further configuration is required.|Esta es la página de prueba para verificar que Nginx está funcionando correctamente.|g; s|For online documentation and support please refer to nginx.org.|Documentación en línea disponible en nginx.org.|g; s|Commercial support is available at nginx.com.|Soporte comercial en nginx.com.|g; s|Thank you for using nginx.|Gracias por usar nginx.|g' /usr/share/nginx/html/index.html

