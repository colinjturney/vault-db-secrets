# Vault DB Secrets Demo

The code in this demo will build a local Consul cluster with a single Vault server. Several utility scripts are provided to configure Dynamic Database Secrets Engine on Vault and to generate credentials for a readonly, readwrite, and superuser role.

## Important Notes

1. **Note:** As of 2nd January 2019, there is an incompatibility between Vagrant 2.2.6 and Virtualbox 6.1.X. Until this incompatibility is fixed, it is recommended to run Vagrant with Virtualbox 6.0.14 instead.

2. **Note:** This demo aims to demonstrate how Postgres credentials can be dynamically generated by Vault. It does **not** intend to demonstrate how to build a Vault and Consul deployment according to any recommended architecture, nor does it intend to demonstrate any form of best practice. Amongst many other things, you should always enable ACLs, configure TLS and never store your Vault unseal keys or tokens on your Vault server!

## Requirements
* The VMs created by the demo will consume a total of 2.5GB memory.
* The demo was tested using Vagrant 2.2.6 and Virtualbox 6.0.14

## What is built?

The demo will build the following Virtual Machines:
* **vault-server**: A single Vault server
* **consul-{1-3}-server**: A cluster of 3 Consul servers within a single Datacenter
* **postgres**: A single server running Postgres

## Provisioning scripts
The following provisioning scripts will be run by Vagrant:
* install-consul.sh: Automatically installs and configures Consul 1.6.2 (open source) on each of the consul-{1-3}-server VMs. A flag allows it to configure a consul client on the Vault VM too.
* install-vault.sh: Automatically installs and configures Vault (open source) on the Vault server.
* install-postgres.sh: Automatically installs and configures Postgres, creating a vault_admin user and a test table that can be used to test Vault credentials on.

## Additional files
The following additional files are also included:
* 0-init-vault.sh: Needs to be run as a manual step to initialise and unseal Vault, login using the root token, enable the database secrets engine and also the userpass auth method
* 1-vault-config-postgres.sh: Creates the database configuration in Vault
* 2-vault-postgres-roles.sh: Create 3 DB roles (readonly, readwrite, superuser) and 3 associated userpass users with policies that let them generate DB credentials.
* 3-readonly-user-creds: Demonstrates how a correctly set policy will prevent 2 out of 3 approles from being able to generate credentials for a given DB role.
* 4-readwrite-user-creds: Demonstrates how a correctly set policy will prevent 2 out of 3 approles from being able to generate credentials for a given DB role.
* 5-superuser-user-creds: Demonstrates how a correctly set policy will prevent 2 out of 3 approles from being able to generate credentials for a given DB role.

## How to get started
Once Vagrant and Virtualbox are installed, to get started just run the following command within the code directory:
```
vagrant up
```
Once vagrant has completely finished, run the following to SSH onto the vault server
```
vagrant ssh vault-server
```
Once SSH'd onto vault-server, run the following commands in sequence:
```
cp /vagrant/{0,1,2,3,4,5}*.sh . ;
chmod 744 {0,1,2,3,4,5)*.sh ;
./0-init-vault.sh ;
```
This will create a file called vault.txt in the directory you run the script in. The file contains a single Vault unseal key and root token, in case you wish to seal or unseal vault in the future. Of course, in a real-life scenario these files should not be generated automatically and not be stored on the vault server.

You can then simply run each script following `0-init-vault.sh` in numerical order to configure Vault's DB secrets engine.

Once everything is built, you should be able to access the following UIs at the following addresses:

* Consul UI: http://10.0.0.11:7500/ui/

If you're having problems, then check your Virtualbox networking configurations. They should be set to the default of NAT. If problems still persist then you might be able to access the UIs via the port forwarding that has been set up- check the Vagrantfile for these ports.

## Support
No support or guarantees are offered with this code. It is purely a demo.

## Future Improvements
* Use Docker containers instead of VMs.
* Other suggested future improvements very welcome.
