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

# Create a database and a user (update variables as needed)
sudo -u postgres psql -c "CREATE USER ihub WITH PASSWORD "trd$Xc*LTju3OrqzM#VVb";"
sudo -u postgres psql -c "CREATE USER ajpproductiondbuser WITH PASSWORD 'AR9&Q[n-59r8=D)zKllH66';"
sudo -u postgres psql -c "CREATE DATABASE ajpproductiondb;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE ajpproductiondb TO ajpproductiondbuser;"


echo "PostgreSQL installation and configuration complete."