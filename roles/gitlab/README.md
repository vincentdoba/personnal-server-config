# Gitlab Configuration

## Run database initialization when playing gitlab role

To run database initialization during gitlab role, you need to ensure that the file ```/opt/gitlab/gitlab_database_initialization.log```. You can delete this file by running the following commad on server as root :

```bash
rm -rf /opt/gitlab/gitlab_database_initialization.log
```
