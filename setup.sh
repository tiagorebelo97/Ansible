#!/bin/bash
# Quick setup script for Ansible repository

set -e

echo "Setting up Ansible environment..."

# Check if ansible is installed
if ! command -v ansible &> /dev/null; then
    echo "Ansible is not installed. Please install Ansible first."
    echo "Run: pip install ansible"
    exit 1
fi

# Install required collections
echo "Installing Ansible collections..."
ansible-galaxy collection install -r requirements.yml

# Create vault password file if it doesn't exist
if [ ! -f .vault_pass ]; then
    echo "Creating vault password file..."
    echo "changeme" > .vault_pass
    chmod 600 .vault_pass
    echo "WARNING: Default vault password created. Change it in .vault_pass file"
fi

# Verify inventory
echo "Verifying inventory syntax..."
ansible-inventory --list -i inventory/hosts.yml > /dev/null

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit inventory/hosts.yml with your server IPs"
echo "2. Edit inventory/group_vars/openshift.yml with your cluster configuration"
echo "3. Run: ansible-playbook playbooks/verify-prerequisites.yml"
echo "4. Run: ansible-playbook playbooks/install-openshift.yml"
