#!/bin/bash

# Update and upgrade the system
apt-get update -y && apt-get upgrade -y

# Install PostgreSQL
apt-get install -y postgresql postgresql-contrib

# Start and enable PostgreSQL service
systemctl start postgresql
systemctl enable postgresql

# Configure PostgreSQL to allow remote access (optional)
echo "listen_addresses = '*'" >> /etc/postgresql/*/main/postgresql.conf

sed -i "/# IPv4 local connections:/a host    all             all             0.0.0.0/0               md5" /etc/postgresql/*/main/pg_hba.conf

# Restart PostgreSQL to apply configuration changes
systemctl restart postgresql

#show server status
sudo systemctl status postgresql

# Create a database and a user (update variables as needed)
sudo -u postgres psql -c "CREATE USER usernmae WITH PASSWORD "xyz";"
sudo -u postgres psql -c "CREATE DATABASE dbname;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE dbname TO dbuser;"
