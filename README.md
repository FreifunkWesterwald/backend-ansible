# ffmyk-ansible
sets up ffmyk supernodes

## usage
- to install arch on hetzner vms run the bootstrap_arch playbook
```
ansible-playbook --vault-id @prompt -i inventory.ini bootstrap_arch.yml
```
- to configure the node run
```
ansible-playbook --vault-id @prompt -i inventory.ini setup_fastd.yml
```
