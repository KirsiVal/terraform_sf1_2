#!/bin/bash

# Update the package repositories and install Apache
sudo yum update -y
sudo yum install httpd -y

# Start the Apache service and enable it on boot
sudo systemctl start httpd
sudo systemctl enable httpd

# Create a simple HTML page
echo "<html><head><title>Hello, World!</title></head><body><h1>Hello, World!</h1></body></html>" | sudo tee /var/www/html/index.html

# Set the correct permissions for the HTML file
sudo chown apache:apache /var/www/html/index.html


sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Ensure Apache starts on boot
sudo systemctl enable httpd

# Start Apache
sudo systemctl start httpd
# Mounting Efs
 #!/bin/bash
sudo yum install -y amazon-efs-utils,  # Install EFS utilities
sudo mkdir -p /mnt/efs,  # Create a mount point
sudo mount -t efs -o tls ${aws_efs_file_system.efs.ip_address}:/ /mnt/efs,  # Mount the EFS file system
sudo chmod 777 /mnt/efs  # Adjust permissions as needed