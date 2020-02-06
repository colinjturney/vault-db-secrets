#!/bin/bash

# Create a readonly database role within Vault

cat <<EOF > readonly.sql
CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}";
EOF

vault write database/roles/readonly db_name=vault_demo \
  creation_statements=@readonly.sql \
  default_ttl=1h max_ttl=24h

# Create the Vault policy associated with the above role

cat <<EOF > readonly.hcl
path "database/creds/readonly" {
  capabilities = [ "read" ]
}
EOF

vault policy write readonly readonly.hcl

# Create a userpass user with the above policy

vault write auth/userpass/users/readonly \
  password=password \
  policies=readonly

# Create a read/write database role within vault

cat <<EOF > readwrite.sql
CREATE ROLE "{{name}}" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
GRANT SELECT ON ALL TABLES IN SCHEMA public TO "{{name}}";
GRANT INSERT ON ALL TABLES IN SCHEMA public TO "{{name}}";
GRANT UPDATE ON ALL TABLES IN SCHEMA public TO "{{name}}";
GRANT DELETE ON ALL TABLES IN SCHEMA public TO "{{name}}";
EOF

vault write database/roles/readwrite db_name=vault_demo \
  creation_statements=@readwrite.sql \
  default_ttl=1h max_ttl=24h

# Create the Vault policy associated with the above role

cat <<EOF > readwrite.hcl
path "database/creds/readwrite" {
  capabilities = [ "read" ]
}
EOF

vault policy write readwrite readwrite.hcl

# Create a userpass user with the above policy

vault write auth/userpass/users/readwrite \
  password=password \
  policies=readwrite

# Create a superuser database role within vault

cat <<EOF > superuser.sql
CREATE ROLE "{{name}}" SUPERUSER WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}';
EOF

vault write database/roles/superuser db_name=vault_demo \
  creation_statements=@superuser.sql \
  default_ttl=1h max_ttl=24h

# Create the Vault policy associated with the above role

cat <<EOF > superuser.hcl
path "database/creds/superuser" {
  capabilities = [ "read" ]
}
EOF

vault policy write superuser superuser.hcl

# Create a userpass user with the above policy

vault write auth/userpass/users/superuser \
  password=password \
  policies=superuser
