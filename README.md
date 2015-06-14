# Sac Ansible Configuration

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

## Add a site

### Setup hostname

* open file *vars/common.yml* with ansible vault :
```bash
ansible-vault edit vars/common.yml
```
* add site hostname in file *vars/common.yml*, for instance : 
```yaml
yoursite_hostname: "yoursite.cedeela.fr" # my new site about manatees
```

### Create ansible tasks and templates

* create a directory *roles/yoursite*
* create a directory *roles/yoursite/tasks*
* create a file *roles/yoursite/tasks/main.yml* containing the following lines :
```yaml
---
- include: yoursite.yml
```
* create a file *roles/yoursite/templates/virtual_host_config*, that will contains nginx virtual host configuration for your site. Below the most default nginx configuration :
```
server {
  listen 80;
  server_name {{ yoursite_hostname|mandatory }};
  root /home/sites/yoursite ;
  server_tokens off;
}
```
* create a file *roles/yoursite/tasks/yoursite.yml*
* in the file *roles/yoursite/tasks/yoursite.yml*, add the task to create site root :
```yaml
- name: Create yoursite directory
  file: path=/home/sites/yoursite state=directory recurse=yes owner=www-data group=www-data mode=0755
```
* in the file *roles/yoursite/tasks/yoursite.yml*, add the following tasks at the end :
```yaml
- name: Create yoursite virtual host
  template: src=virtual_host_config dest=/etc/nginx/sites-available/yoursite
  notify: Reload nginx

- name: Create yoursite link in site-enabled
  file: src=/etc/nginx/sites-available/yoursite state=link dest=/etc/nginx/sites-enabled/yoursite
  notify: Reload nginx

- name: Create line for yoursite in /etc/hosts
  lineinfile: dest=/etc/hosts line="127.0.0.1 {{ yoursite_hostname }}" insertafter="^127"
```

### Add dependencies

* create a directory *roles/yoursite/meta*
* create a file *roles/yoursite/meta/main.yml*
* add the following lines in file *roles/yoursite/meta/main.yml*
```yaml
---
dependencies:
  - nginx
  - commons
```

### Activate your site in ansible run

* add the following line to *site.yml*, in section *roles* :
```yaml
- role: yoursite
  tags:
    - yoursite
```
