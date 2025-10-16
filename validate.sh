#!/bin/bash
# Validation script to check repository structure and Ansible configuration

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
PASS=0
FAIL=0
WARN=0

echo "================================"
echo "Ansible Repository Validation"
echo "================================"
echo ""

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

check_warn() {
    echo -e "${YELLOW}!${NC} $1"
    ((WARN++))
}

# Check Ansible installation
echo "Checking prerequisites..."
if command -v ansible &> /dev/null; then
    check_pass "Ansible is installed ($(ansible --version | head -1))"
else
    check_fail "Ansible is not installed"
fi

# Check Python
if command -v python3 &> /dev/null; then
    check_pass "Python3 is installed ($(python3 --version))"
else
    check_fail "Python3 is not installed"
fi

echo ""
echo "Checking repository structure..."

# Check directories
for dir in inventory playbooks roles templates files docs; do
    if [ -d "$dir" ]; then
        check_pass "Directory exists: $dir"
    else
        check_fail "Directory missing: $dir"
    fi
done

# Check essential files
for file in ansible.cfg requirements.yml README.md Makefile setup.sh .gitignore; do
    if [ -f "$file" ]; then
        check_pass "File exists: $file"
    else
        check_fail "File missing: $file"
    fi
done

echo ""
echo "Checking inventory..."

if [ -f "inventory/hosts.yml" ]; then
    check_pass "Inventory file exists"
    
    # Validate inventory syntax
    if ansible-inventory --list -i inventory/hosts.yml > /dev/null 2>&1; then
        check_pass "Inventory syntax is valid"
    else
        check_fail "Inventory syntax is invalid"
    fi
else
    check_fail "Inventory file missing"
fi

echo ""
echo "Checking playbooks..."

for playbook in playbooks/*.yml; do
    if [ -f "$playbook" ]; then
        playbook_name=$(basename "$playbook")
        if ansible-playbook --syntax-check "$playbook" > /dev/null 2>&1; then
            check_pass "Playbook syntax valid: $playbook_name"
        else
            check_fail "Playbook syntax invalid: $playbook_name"
        fi
    fi
done

echo ""
echo "Checking roles..."

for role in roles/*; do
    if [ -d "$role" ]; then
        role_name=$(basename "$role")
        
        # Check role structure
        if [ -f "$role/tasks/main.yml" ]; then
            check_pass "Role has tasks: $role_name"
        else
            check_warn "Role missing tasks: $role_name"
        fi
        
        if [ -f "$role/meta/main.yml" ]; then
            check_pass "Role has meta: $role_name"
        else
            check_warn "Role missing meta: $role_name"
        fi
    fi
done

echo ""
echo "Checking documentation..."

for doc in README.md CONTRIBUTING.md docs/INSTALLATION_GUIDE.md docs/PROJECT_OVERVIEW.md docs/QUICK_REFERENCE.md; do
    if [ -f "$doc" ]; then
        check_pass "Documentation exists: $doc"
    else
        check_warn "Documentation missing: $doc"
    fi
done

echo ""
echo "Checking configuration files..."

# Check ansible.cfg
if [ -f "ansible.cfg" ]; then
    if grep -q "inventory.*=" ansible.cfg; then
        check_pass "ansible.cfg has inventory setting"
    else
        check_warn "ansible.cfg missing inventory setting"
    fi
    
    if grep -q "roles_path.*=" ansible.cfg; then
        check_pass "ansible.cfg has roles_path setting"
    else
        check_warn "ansible.cfg missing roles_path setting"
    fi
fi

echo ""
echo "================================"
echo "Validation Summary"
echo "================================"
echo -e "${GREEN}Passed:${NC} $PASS"
echo -e "${YELLOW}Warnings:${NC} $WARN"
echo -e "${RED}Failed:${NC} $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ Repository validation passed!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Run: make install"
    echo "2. Configure: inventory/hosts.yml"
    echo "3. Configure: inventory/group_vars/openshift.yml"
    echo "4. Run: make verify"
    echo "5. Run: make deploy"
    exit 0
else
    echo -e "${RED}✗ Repository validation failed!${NC}"
    echo "Please fix the errors above before proceeding."
    exit 1
fi
