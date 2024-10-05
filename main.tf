# Configuración del proveedor de AWS

# Creación de la VPC
resource "aws_vpc" "cloud2_vpc" {
  cidr_block = "30.0.0.0/16"  # Rango de IP para la VPC
  enable_dns_support = true    # Habilitar soporte DNS
  enable_dns_hostnames = true   # Habilitar nombres de host DNS

  tags = {
    Name = "cloud2_vpc"         # Etiqueta para la VPC
  }
}

# Subredes públicas

# Primera subred pública
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.cloud2_vpc.id  # ID de la VPC donde se crea la subred
  cidr_block        = "30.0.1.0/24"           # Rango de IP para la subred pública 1
  availability_zone = "us-west-2a"            # Zona de disponibilidad

  tags = {
    Name = "public_subnet_1"  # Etiqueta para la subred pública 1
  }
}

# Segunda subred pública
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.cloud2_vpc.id  # ID de la VPC donde se crea la subred
  cidr_block        = "30.0.2.0/24"           # Rango de IP para la subred pública 2
  availability_zone = "us-west-2b"            # Zona de disponibilidad

  tags = {
    Name = "public_subnet_2"  # Etiqueta para la subred pública 2
  }
}

# Subredes privadas

# Primera subred privada
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.cloud2_vpc.id  # ID de la VPC donde se crea la subred
  cidr_block        = "30.0.3.0/24"           # Rango de IP para la subred privada 1
  availability_zone = "us-west-2a"            # Zona de disponibilidad

  tags = {
    Name = "private_subnet_1" # Etiqueta para la subred privada 1
  }
}

# Segunda subred privada
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.cloud2_vpc.id  # ID de la VPC donde se crea la subred
  cidr_block        = "30.0.4.0/24"           # Rango de IP para la subred privada 2
  availability_zone = "us-west-2b"            # Zona de disponibilidad

  tags = {
    Name = "private_subnet_2" # Etiqueta para la subred privada 2
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.cloud2_vpc.id  # ID de la VPC a la que se asocia el gateway

  tags = {
    Name = "internet_gateway"    # Etiqueta para el Internet Gateway
  }
}

# Tabla de enrutamiento para subredes públicas
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.cloud2_vpc.id  # ID de la VPC a la que pertenece la tabla de enrutamiento

  route {
    cidr_block = "0.0.0.0/0"        # Ruta para todo el tráfico saliente
    gateway_id = aws_internet_gateway.igw.id  # ID del Internet Gateway
  }

  tags = {
    Name = "public_route_table"    # Etiqueta para la tabla de enrutamiento pública
  }
}

# Asociación de la tabla de enrutamiento a la subred pública 1
resource "aws_route_table_association" "public_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id  # ID de la subred pública 1
  route_table_id = aws_route_table.public_rt.id    # ID de la tabla de enrutamiento pública
}

# Asociación de la tabla de enrutamiento a la subred pública 2
resource "aws_route_table_association" "public_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id  # ID de la subred pública 2
  route_table_id = aws_route_table.public_rt.id    # ID de la tabla de enrutamiento pública
}

# Crear un par de llaves para acceder a las instancias EC2
resource "aws_key_pair" "main_key" {
  key_name   = "cloud2-terraform"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAxTzY2lcP5Giu2B0jjRMxg4HAzJymS80OoH88No2ZHZd2eHSv0y24eTEQJZzqTIy6nD9Q2lF69aO6St8A1SG+zpUXcDLN3qICzxxw2mgr3nUke7ocZM64JI2stAMAPN1w9nRGR6dob/s2pqt0hiBKI5WKybmbxd6yKA3RHITAO0g8/UP7Leg6G8wbxqUgK3qcp54YgXxnrmyxq+wcHm7Vm/R2533TReCZzwdwU8fxt2uDNFDG5Rz2Osh2w22D1OaBxNi/haN9klezkPY7fcE3prLAxKiHXbOYOhuNIl94FIOvXwqiw6GEiZwm9gXtPid64yNd6nnfNjG4VBfLRyUSkAzHyGyFOeY3xTlThrnIv4FpnDlz1tvvfrpGp8W+psVg4nMRb68mAsZ4tcF2zpRdd7MW6z5ZXQwILPa9UlI/tPRX7TLtCfnE9a5R1zG4QGB2W7NslH2SEkd0+jCaAvo0G84EwqLhkgvhF5YOToN0gCd30j4h01hj3jynBf21+tPCF/3iys5/L5Klhqa/vnllNAxP8yToY7EVeMXQ2fKOyEv25W6zLM8S/KcZOKp50PJEH+2EnETszkfhCS5jhgEsOulrtjXTo/0O5bXcVHOzPBoiszaJijflPmcKed2EGzug6gy4rGCEyduCvdWUTySkdwPPXcpcneagd0BjvIDp/Q== lpestrada@unicesar.edu.co"
}


# Security Group para permitir acceso SSH y HTTP a las instancias
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.cloud2_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir acceso SSH desde cualquier lugar
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitir tráfico HTTP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PublicSecurityGroup"
  }
}

# Crear una instancia EC2 en la primera subred pública
resource "aws_instance" "public_instance_1" {
  ami             = "ami-0d081196e3df05f4d"  # AMI de ejemplo, usa una AMI válida
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_1.id
  key_name        = aws_key_pair.main_key.key_name
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "PublicInstance1"
  }
}

# Crear una instancia EC2 en la segunda subred pública
resource "aws_instance" "public_instance_2" {
  ami             = "ami-0d081196e3df05f4d"  # AMI de ejemplo, usa una AMI válida
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet_2.id
  key_name        = aws_key_pair.main_key.key_name
vpc_security_group_ids = [aws_security_group.public_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "PublicInstance2"
  }
}

# Salida opcional de las direcciones IP públicas de las instancias EC2
output "public_instance_1_ip" {
  value = aws_instance.public_instance_1.public_ip
}

output "public_instance_2_ip" {
  value = aws_instance.public_instance_2.public_ip
}
  