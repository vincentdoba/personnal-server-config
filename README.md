# Sac Ansible Configuration

command to copy public key to vincent .ssh file

```bash
ssh vincent@server 'bash -s' < init.sh
```

command to launch ansible : 

```bash
ansible-playbook -i playbook/inventories/test playbook/site.yml 
```
