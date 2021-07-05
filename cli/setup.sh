#!/bin/bash


export TOWER_HOST=https://awx.central.gp.local
export EXEC_ENV_ID=3
$(TOWER_USERNAME=admin TOWER_PASSWORD="abcdef" awx login -f human -k)

echo ""
echo "Create Project"
awx projects create --wait -k \
    --name "Bundle-Test" \
    --organization 1 \
    --scm_type git \
    --scm_url "https://github.com/gepaplexx/bundle-playbook" \
    -f human

echo ""
echo "Create Inventory"
awx inventory create --wait -k \
    --name "Bundle-Test" \
    --organization 1 \
    -f human

echo ""
echo "Create Inventory Source"
awx inventory_source create --wait -k \
    --inventory "Bundle-Test" \
    --name "Git" \
    --source scm \
    --source_path "hosts.ini" \
    --source_project "Bundle-Test" \
    --overwrite true \
    --overwrite_vars true \
    --update_on_launch true \
    -f human


echo ""
echo "Create Credentials"
awx credentials create --wait -k \
    --name "play.gepaplexx.com" \
    --organization 1 \
    --credential_type 16 \
    --inputs '{"host": "https://172.16.21.3:6443","verify_ssl": false,"bearer_token": "encrypted"}' \
    -f human

echo ""
echo "Create Execution Env"
awx execution_environments create --wait -k \
    --name "AWX EE with HELM" \
    --image "cbacon93/awx-ee-helm:latest" \
    --pull always \
    -f human


echo ""
echo "Create Job Template Install"
awx job_templates create --wait -k \
    --name "Bundle-Test Install" \
    --job_type run \
    --inventory "Bundle-Test" \
    --project "Bundle-Test" \
    --playbook "install.yml" \
    --ask_credential_on_launch true \
    --execution_environment "${EXEC_ENV_ID}" \
    -f human

echo ""
echo "Create Job Template Uninstall"
awx job_templates create --wait -k \
    --name "Bundle-Test Uninstall" \
    --job_type run \
    --inventory "Bundle-Test" \
    --project "Bundle-Test" \
    --playbook "remove.yml" \
    --ask_credential_on_launch true \
    --execution_environment "${EXEC_ENV_ID}" \
    -f human