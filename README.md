# Freifunk Westerwald Backend Ansible
Ansible files to configure Freifunk super nodes on debian

## Prepare
Add a .ansible_vault file to the project and insert the secret.  
Use ``echo -n STRING | ansible-vault encrypt_string`` to encrypt strings.

## Usage
To configure a node, add hosts to the inventory and specify the needed host and group vars.

Start rollout with:
```
ansible-playbook -i inventory.ini setup_fastd.yml
```
