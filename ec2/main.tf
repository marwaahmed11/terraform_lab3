# public ec2 instance
resource "aws_instance" "ec2_public" {
    count = length(var.public-ec2-name)
    tags = {
        Name = var.public-ec2-name[count.index]
    }
    key_name = "test"
    ami = var.ami-id
    subnet_id = var.public-subnet-id[count.index]
    instance_type = "t2.micro"
    associate_public_ip_address = "true" #enable ip 
    # security_groups = [var.security-group-name]
    vpc_security_group_ids = [var.security-group-id]
  
    provisioner "local-exec" {
        command = "echo ${var.public-ec2-name[count.index]} ${self.public_ip} >> ./all-ips.txt"
      
    }
    provisioner "remote-exec" {
        inline =  ["sudo apt update -y",
        "sudo apt install -y nginx",
        "echo 'server { \n listen 80 default_server; \n  listen [::]:80 default_server; \n  server_name _; \n  location / { \n  proxy_pass http://${var.alb-private-dns-name}; \n  } \n}' > default",
        "sudo mv default /etc/nginx/sites-enabled/default",
        "sudo systemctl stop nginx",
        "sudo systemctl start nginx"
        ]
    }
    connection {
        type = "ssh"
        host = self.public_ip
        user = "ubuntu"
        private_key = file("./test.pem")
        timeout = "4m"
    }

}

# private ec2 instance
resource "aws_instance" "ec2_private" {
    count = length(var.private-ec2-name)
    tags = {
        Name = var.private-ec2-name[count.index]
    }
    ami =  var.ami-id
    subnet_id = var.private-subnet-id[count.index]
    instance_type = "t2.micro"
    associate_public_ip_address = "false" #enable ip 
    vpc_security_group_ids = [var.security-group-id]
  
    user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2
    sudo systemctl start apache2
    sudo systemctl enable apache2
    echo "hello from private network " >/var/www/html/index.html
    EOF
    
}


