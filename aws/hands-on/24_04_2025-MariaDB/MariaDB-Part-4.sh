# Part 4 - Creating a Client Instance and Connecting to MariaDB Server Instance Remotely

# Launch EC2 Instance (Ubuntu 22.04) and name it as MariaDB-Client on Ubuntu.

# AMI: Ubuntu 22.04
# Instance Type: t2.micro
# Security Group
#   - SSH           -----> 22    -----> Anywhere

# Connect to EC2 instance with SSH.

# Update instance.
sudo apt update

# Install the mariadb-client.
sudo apt-get install mariadb-client -y

# Connect the clarusdb on MariaDB Server on the other EC2 instance (pw:clarus1234).
mysql -h ec2-3-94-163-77.compute-1.amazonaws.com -u clarususer -p

# Show that clarususer can do same db operations on MariaDB Server instance.
SHOW DATABASES;
USE clarusdb;
SHOW TABLES;
SELECT * FROM employees;
SELECT * FROM offices;
SELECT first_name, last_name, salary, city, state FROM employees INNER JOIN offices ON employees.office_id=offices.office_id WHERE employees.salary > 100000;

# Close the mysql terminal.
EXIT;

# DO NOT FORGET TO TERMINATE THE INSTANCES YOU CREATED!!!!!!!!!!

Ref: https://mariadb.org/documentation/
https://mariadb.com/docs/skysql/connect/clients/mariadb-client/

# Launch EC2 Instance (Amazon-Lınux-2023) 

# AMI: al2023-ami-2023.7.20250414.0-kernel-6.1-x86_64
# Instance Type: t2.micro
# Security Group
#   - SSH           -----> 22    -----> Anywhere

# Connect to EC2 instance with SSH.

```bash
sudo dnf update -y
sudo dnf install mariadb105 -y
# Connect the clarusdb on MariaDB Server on the other EC2 instance (pw:clarus1234).
mysql -h <host-address> -u <username> -p
mysql -h ec2-3-94-163-77.compute-1.amazonaws.com -u clarususer -p