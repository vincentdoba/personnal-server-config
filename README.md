# Personnal Server Ansible Configuration

## Run ansible

**Note : deployment of this server was tested on a freshly installed debian jessie (debian 8)**

*remote_user* is the user you use to connect to server using ssh. It should not be root.

### Notes on prerequisite

It may be necessary to install the right version of gnupg before running ansible. Indeed, it seems there is conflict between
gnupg version necessary for python-apt and the version available for debian (2.2.12 vs 2.2.20). You can install the right version
by typing the following commands:

```bash
apt-get update
apt-get install gnupg=2.2.12-1+deb10u1 gpgv=2.2.12-1+deb10u1
```

### Using connection with ssh keys

command to copy public key to remote user .ssh file

```bash
ssh-copy-id remote_user@server
```

command to launch ansible : 

```bash
ansible-playbook -i inventories/test site.yml -u remote_user --ask-become-pass --ask-vault-pass
```

### Using connection with ssh password

* Install sshpass, for instance on Archlinux :
```
pacman -Sy sshpass
```
* play ansible configuration on remote host :
```bash
ansible-playbook -i inventories/test site.yml -u remote_user --ask-pass --ask-become-pass --ask-vault-pass
```

### Special commands

**Note : deployment using ssh key authentication, add argument *--ask-pass* to use password authentication**

command to launch ansible at a special task

```bash
ansible-playbook -i inventories/test site.yml -u remote_user --ask-become-pass --ask-vault-pass --start-at-task="My Task Name"
```

command to launch ansible at a special tag

```bash
ansible-playbook -i inventories/test site.yml -u remote-user --ask-become-pass --ask-vault-pass --tags="My tag name"
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
ansible-playbook -i inventories/test site.yml --u remote_user @doba-ask-become-pass --ask-vault-pass --tags="username"
```
