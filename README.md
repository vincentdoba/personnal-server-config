# Sac Ansible Configuration

**Note : deployment of this server was tested on a freshly installed debian jessie (debian 8)**

command to copy public key to vincent .ssh file

```bash
ssh vincent@server 'bash -s' < init.sh
```

command to launch ansible : 

```bash
ansible-playbook -i playbook/inventories/test playbook/site.yml --ask-su-pass
```

command to launch ansible at a special task

```bash
ansible-playbook -i playbook/inventories/test playbook/site.yml --ask-su-pass --start-at-task="My Task Name"

command to launch ansible at a special tag

```bash
ansible-playbook -i playbook/inventories/test playbook/site.yml --ask-su-pass --tags="My tag name"
```

**Note :** each role has its own tags, which is the name of the role

## Add a site

* add site hostname in file *playbook/vars/common.yml*, for instance : 
```yaml
yoursite_hostname: "yoursite.cedeela.fr" # my new site about manatees
```
* create a directory *playbook/roles/yoursite*
* create a file *playbook/roles/yoursite/tasks/main.yml* containing the following lines :
```yaml
---
- include: yoursite.yml
  tags:
    - yoursite
```
* create a file *playbook/roles/yoursite/templates/virtual_host_config*, that will contains nginx virtual host configuration for your site. Below the most default nginx configuration :
```
server {
  listen 80;
  server_name {{ yoursite_hostname|mandatory }};
  root /home/sites/yoursite ;
  server_tokens off;
}
```
* create a file *playbook/roles/yoursite/tasks/yoursite.yml*
* in the file *playbook/roles/yoursite/tasks/yoursite.yml*, add the task to create site root :
```yaml
- name: Create yoursite directory
  file: path=/home/sites/yoursite state=directory recurse=yes owner=www-data group=www-data mode=0755
  become: yes
  become_method: su
```
* in the file *playbook/roles/yoursite/tasks/yoursite.yml*, add the following tasks at the end :
```yaml
- name: Create yoursite virtual host
  template: src=virtual_host_config dest=/etc/nginx/sites-available/yoursite
  notify: Reload nginx
  become: yes
  become_method: su

- name: Create yoursite link in site-enabled
  file: src=/etc/nginx/sites-available/yoursite state=link dest=/etc/nginx/sites-enabled/yoursite
  notify: Reload nginx
  become: yes
  become_method: su

- name: Create line for yoursite in /etc/hosts
  lineinfile: dest=/etc/hosts line="127.0.0.1 {{ yoursite_hostname }}" insertafter="^127"
  become: yes
  become_method: su
```
* add the following line to *playbook/site.yml*, in section *roles* :
```yaml
- yoursite
```
