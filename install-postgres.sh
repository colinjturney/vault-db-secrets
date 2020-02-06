#!/bin/bash

# Install postgres

apt-get install -y postgresql postgresql-client

echo "hostnossl   vault_demo      vault_admin 10.0.0.10/32            trust" >> /etc/postgresql/10/main/pg_hba.conf

echo "listen_addresses = '*'" >> /etc/postgresql/10/main/postgresql.conf

service postgresql restart

# Write postgres script to create Vault Admin user

cat <<EOF > /tmp/pg_vault_admin.sql
CREATE USER vault_admin WITH PASSWORD 'vault' SUPERUSER;

CREATE DATABASE vault_demo;

EOF

/bin/su -c "psql -f /tmp/pg_vault_admin.sql" - postgres

cat <<EOF > /tmp/pg_vault_tbl.sql
\c vault_demo

CREATE TABLE accounts(
  user_id INTEGER NOT NULL
);

INSERT INTO accounts(user_id) VALUES(1234);

EOF

/bin/su -c "psql -f /tmp/pg_vault_tbl.sql" - postgres
