# Personnal Server Ansible Configuration

## Run ansible

**Note : deployment of this server was tested on a freshly installed debian jessie (debian 8)**

*remote_user* is the user you use to connect to server using ssh. It should not be root.

### Using connection with ssh keys

command to copy public key to remote user .ssh file

```bash
ssh-copy-id remote_user@server
```

command to launch ansible : 

```bash
ansible-playbook -i inventories/test site.yml -u remote_user --ask-su-pass --ask-vault-pass
```

### Using connection with ssh password

* Install sshpass, for instance on Archlinux :
```
pacman -Sy sshpass
```
* play ansible configuration on remote host :
```bash
ansible-playbook -i inventories/test site.yml -u remote_user --ask-pass --ask-su-pass --ask-vault-pass
```

### Special commands

**Note : deployment using ssh key authentication, add argument *--ask-pass* to use password authentication**

command to launch ansible at a special task

```bash
ansible-playbook -i inventories/test site.yml -u remote_user --ask-su-pass --ask-vault-pass --start-at-task="My Task Name"
```

command to launch ansible at a special tag

```bash
ansible-playbook -i inventories/test site.yml -u remote-user --ask-su-pass --ask-vault-pass --tags="My tag name"
```

**Note :** each role has its own tags, which is the name of the role

## Add an user

* Create a file *roles/users/tasks/username.yml*
* Add following line to *roles/users/tasks/main.yml*
```yaml
- include: username.yml
  tags:
    - username
```
* You can put your personnal config files in *roles/users/files/username*

### Run ansible for your user

By running the following command, you will run only your own user configuration

```bash
ansible-playbook -i inventories/test site.yml --ask-su-pass --ask-vault-pass --tags="username"
```
