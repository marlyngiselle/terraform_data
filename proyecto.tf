provider "aws" {}

# -------------- EXTRAER DATOS POR DEFECTO DENTRO LA VPC ---------------

data "aws_vpc" "por_defecto" { default = true }

data "aws_subnet" "por_defecto" {
  vpc_id = data.aws_vpc.por_defecto.id

  filter {
    name   = "tag:Name"
    values = ["subred-default-1"]
  }
}

data "aws_security_group" "que_creamos" {
  vpc_id = data.aws_vpc.por_defecto.id

  filter {
    name   = "tag:Name"
    values = ["sg-creado-manualmente"]
  }
}

# ------------------- CREAR RECURSOS ------------------------------------

resource "aws_key_pair" "llave_wsl" {
  key_name = "llave-wsl"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_security_group_rule" "conexion_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = data.aws_security_group.que_creamos.id
}

resource "aws_instance" "servidor1" {
  tags                   = { Name = "servidor1" }
  ami                    = "ami-0a21d1c76ac56fee7"
  instance_type          = "t2.micro"
  key_name               = resource.aws_key_pair.llave_wsl.key_name 
  vpc_security_group_ids = [data.aws_security_group.que_creamos.id]
  subnet_id              = data.aws_subnet.por_defecto.id
}

resource "aws_instance" "servidor2" {
  tags                   = { Name = "servidor2" }
  ami                    = "ami-0a21d1c76ac56fee7"
  instance_type          = "t2.micro"
  key_name               = resource.aws_key_pair.llave_wsl.key_name 
  vpc_security_group_ids = [data.aws_security_group.que_creamos.id]
  subnet_id              = data.aws_subnet.por_defecto.id
}

resource "aws_instance" "servidor3" {
  tags                   = { Name = "servidor3" }
  ami                    = "ami-0a21d1c76ac56fee7"
  instance_type          = "t2.micro"
  key_name               = resource.aws_key_pair.llave_wsl.key_name 
  vpc_security_group_ids = [data.aws_security_group.que_creamos.id]
  subnet_id              = data.aws_subnet.por_defecto.id
}

# ------------------- IMPRIMIR EN PANTALLA ------------------------------------

output "La_IP_publica" { value = resource.aws_instance.servidor1.public_ip }