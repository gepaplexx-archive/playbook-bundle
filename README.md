# Bundle Playbook

Dieses Playbook kann zum Installieren von BKEs genutzt werden.  

## Setup
```
python3 -m virtualenv venv
. venv/bin/activate
pip install -r requirements.txt
ansible-galaxy collection install -r requirements.yml

# installieren
ansible-playbook install.yml -i hosts.ini

# deinstallieren
ansible-playbook remove.yml -i hosts.ini
```


## Settings

In group_vars/all.yml können zu installierende BKEs via helm charts eingestellt werden.