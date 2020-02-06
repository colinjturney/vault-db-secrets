#!/bin/bash

# Configure the postgres secrets engine

vault write database/config/vault_demo \
  plugin_name=postgresql-database-plugin \
  allowed_roles=readonly \
  connection_url=postgresql://vault_admin:vault@10.0.0.14:5432/vault_demo?sslmode=disable
