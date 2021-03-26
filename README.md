# Personnal Server Ansible Configuration

## Run ansible

**Note : deployment of this server was tested on a freshly installed debian stretch (debian 9)**

*remote_user* is the user you use to connect to server using ssh. It should not be root.

### Prerequisite

Connect to your server as root and perform the following tasks

#### Create your user

You need to create your remote_user as follow 

```bash
adduser remote_user
```

#### Install compulsory packages

You need python-apt installed to use apt module of ansible

```bash
apt-get update
apt-get install python-apt
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
