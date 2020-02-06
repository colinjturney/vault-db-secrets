#!/bin/bash

vault login -method=userpass username=readonly password=password

# Attempt to read from readonly credentials

vault read database/creds/readonly

# Attempt to read from readwrite credentials

vault read database/creds/readwrite

# Attempt to read from superuser credentials

vault read database/creds/superuser
