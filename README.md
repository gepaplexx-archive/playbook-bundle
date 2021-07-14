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

## Beispiele

```
bundle_repositories:
  - name: gepaplexx
    url: https://gepaplexx.github.io/gp-helm-charts/

bundle_packages:
  - chart_ref: gepaplexx/gp-app
    name: test-service
    namespace: bundle-test
    parameters:
      gps2i:
        enabled: true
        build:
          uri: http://github.com/gepaplexx/gp-test-services
          ref: develop
          contextDir: serviceA
      deploy:
        replicas: 2
        route:
          enabled: false
```

```
bundle_packages:
  - chart_ref: gepaplexx/gp-java-s2i
    name: test-service-build
    namespace: bundle-test
    create_namespace: false
    parameters:
      build:
        uri: http://github.com/gepaplexx/gp-test-services
        ref: develop
        contextDir: serviceA

  - chart_ref: gepaplexx/gp-app
    name: test-service
    namespace: bundle-test
    create_namespace: false
    parameters:
      image:
        name: bundle-test-build-quarkus
        fromImageStream: true
      deploy:
        replicas: 2
        route:
          enabled: false
```