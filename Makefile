.PHONY: help install verify setup clean lint

help: ## Display this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Install Ansible collections and dependencies
	ansible-galaxy collection install -r requirements.yml

verify: ## Verify prerequisites on all nodes
	ansible-playbook playbooks/verify-prerequisites.yml

setup: ## Run initial setup
	./setup.sh

deploy: ## Deploy OpenShift cluster
	ansible-playbook playbooks/install-openshift.yml

post-install: ## Run post-installation configuration
	ansible-playbook playbooks/post-install-config.yml

ping: ## Test connectivity to all hosts
	ansible all -m ping

show-inventory: ## List inventory
	ansible-inventory --list -i inventory/hosts.yml

lint: ## Lint Ansible playbooks (requires ansible-lint)
	@if command -v ansible-lint >/dev/null 2>&1; then \
		ansible-lint playbooks/*.yml; \
	else \
		echo "ansible-lint not installed. Skipping..."; \
	fi

syntax: ## Check playbook syntax
	ansible-playbook --syntax-check playbooks/install-openshift.yml
	ansible-playbook --syntax-check playbooks/verify-prerequisites.yml
	ansible-playbook --syntax-check playbooks/post-install-config.yml

clean: ## Clean temporary files
	find . -name "*.retry" -delete
	find . -name "*.log" -delete
	find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true

facts: ## Gather facts from all hosts
	ansible all -m setup

check: ## Dry-run installation playbook
	ansible-playbook playbooks/install-openshift.yml --check

diff: ## Show what would change
	ansible-playbook playbooks/install-openshift.yml --check --diff
