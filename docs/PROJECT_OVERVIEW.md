# Ansible IaC Repository - Project Overview

## Purpose

This repository serves as a comprehensive Infrastructure as Code (IaC) solution using Ansible for:
- OpenShift cluster installation and management
- Server configuration and provisioning
- Application deployment automation
- Infrastructure maintenance and operations

## Key Features

### OpenShift Cluster Installation
- **Automated 6-node cluster setup**: 3 masters + 3 workers
- **User Provisioned Infrastructure (UPI)**: Full control over infrastructure
- **Highly available configuration**: Multiple masters for HA control plane
- **Scalable worker nodes**: Easy to add more workers

### Infrastructure as Code
- **Version controlled**: All infrastructure defined in code
- **Repeatable deployments**: Same configuration every time
- **Documented processes**: Clear documentation for all procedures
- **Modular design**: Reusable roles and playbooks

### Automation Features
- **Prerequisites verification**: Automatic checks before installation
- **Network configuration**: Firewall, DNS, and network setup
- **Container runtime**: CRI-O installation and configuration
- **Post-installation tasks**: Cluster validation and configuration

## Repository Structure

```
├── ansible.cfg                 # Ansible configuration
├── requirements.yml            # Collection dependencies
├── inventory/                  # Inventory and variables
│   ├── hosts.yml              # Node definitions
│   └── group_vars/            # Group-specific variables
├── playbooks/                  # Automation playbooks
│   ├── install-openshift.yml  # Main installation
│   ├── verify-prerequisites.yml
│   └── post-install-config.yml
├── roles/                      # Reusable automation roles
│   ├── common/                # Base configuration
│   ├── prerequisites/         # OpenShift prerequisites
│   ├── bootstrap/             # Bootstrap setup
│   ├── master/                # Master node config
│   ├── worker/                # Worker node config
│   └── finalize/              # Finalization tasks
├── templates/                  # Configuration templates
├── docs/                       # Documentation
└── Makefile                    # Common commands
```

## Quick Start

```bash
# 1. Clone repository
git clone <repository-url>
cd Ansible

# 2. Install dependencies
make install

# 3. Configure inventory
vim inventory/hosts.yml
vim inventory/group_vars/openshift.yml

# 4. Verify prerequisites
make verify

# 5. Deploy OpenShift
make deploy

# 6. Post-installation
make post-install
```

## Technologies Used

- **Ansible**: Automation engine
- **OpenShift**: Container platform (Kubernetes-based)
- **CRI-O**: Container runtime
- **RHEL/CentOS**: Operating system
- **Python**: Automation scripts

## Architecture

### Cluster Layout

```
┌─────────────────────────────┐
│      Load Balancer          │
│   API (6443) + Ingress      │
└─────────────────────────────┘
              │
    ┌─────────┼─────────┐
    ▼         ▼         ▼
┌─────────┬─────────┬─────────┐
│Master01 │Master02 │Master03 │  Control Plane
│ etcd    │ etcd    │ etcd    │  (HA)
└─────────┴─────────┴─────────┘
              │
    ┌─────────┼─────────┐
    ▼         ▼         ▼
┌─────────┬─────────┬─────────┐
│Worker01 │Worker02 │Worker03 │  Compute Nodes
│Workloads│Workloads│Workloads│  (Applications)
└─────────┴─────────┴─────────┘
```

### Network Flow

1. External traffic → Load Balancer
2. API requests → Masters (6443)
3. Application traffic → Workers (80/443)
4. Internal cluster communication → Overlay network

## Development Workflow

1. **Plan**: Define infrastructure requirements
2. **Code**: Write Ansible playbooks and roles
3. **Test**: Verify with dry-run and syntax checks
4. **Deploy**: Execute automation
5. **Validate**: Confirm deployment success
6. **Document**: Update documentation

## Best Practices

### Code Quality
- Use descriptive variable names
- Add comments for complex logic
- Follow YAML formatting standards
- Use tags for selective execution

### Security
- Store secrets in Ansible Vault
- Use SSH keys for authentication
- Apply principle of least privilege
- Keep software updated

### Operations
- Always verify prerequisites
- Use dry-run before deployment
- Monitor installation progress
- Keep backups of configurations

## Playbook Descriptions

### install-openshift.yml
Main playbook that orchestrates the complete OpenShift installation across all nodes.

**Execution time**: ~1.5-2 hours

**Steps**:
1. Common configuration on all nodes
2. Install prerequisites (CRI-O, kernel modules)
3. Bootstrap cluster initialization
4. Master node configuration
5. Worker node configuration
6. Finalization and validation

### verify-prerequisites.yml
Validates that all nodes meet the minimum requirements for OpenShift.

**Checks**:
- OS version compatibility
- CPU and memory resources
- Disk space availability
- Network connectivity
- Python installation

### post-install-config.yml
Performs post-installation configuration and validation.

**Tasks**:
- Verify cluster accessibility
- Check cluster operators status
- Display node information
- Create application namespaces

## Role Descriptions

### common
Base configuration applied to all nodes: hostname, timezone, NTP, basic packages.

### prerequisites
OpenShift prerequisites: container runtime, kernel modules, firewall, client tools.

### bootstrap
Bootstrap node setup and OpenShift installer preparation.

### master
Master node specific configuration for control plane.

### worker
Worker node configuration for running application workloads.

### finalize
Installation finalization, validation, and information display.

## Variables

### Cluster Configuration
- `cluster_name`: Name of the OpenShift cluster
- `base_domain`: Base domain for cluster DNS
- `openshift_version`: OpenShift version to install

### Network Configuration
- `cluster_network_cidr`: Pod network CIDR
- `service_network`: Service network CIDR
- `dns_servers`: DNS server addresses

### Node Configuration
- `master_vcpus`: Master node CPU count
- `master_memory`: Master node memory
- `worker_vcpus`: Worker node CPU count
- `worker_memory`: Worker node memory

## Maintenance

### Adding Nodes
```bash
# Add node to inventory
vim inventory/hosts.yml

# Deploy to new node
ansible-playbook playbooks/install-openshift.yml --limit <new-node>
```

### Updating Configuration
```bash
# Update variables
vim inventory/group_vars/openshift.yml

# Apply changes
make deploy
```

### Backup
```bash
# Backup etcd (on master nodes)
oc debug node/<master-node>
chroot /host
/usr/local/bin/cluster-backup.sh /home/core/backup
```

## Troubleshooting

### Common Issues

**Connection refused**
- Check SSH connectivity
- Verify firewall rules
- Confirm correct IP addresses

**Prerequisites fail**
- Review hardware requirements
- Check OS compatibility
- Verify disk space

**Installation hangs**
- Check bootstrap logs
- Verify network connectivity
- Review cluster operator status

### Debug Commands

```bash
# Test connectivity
make ping

# Check inventory
make inventory

# Dry run
make check

# Gather facts
make facts
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on:
- Reporting issues
- Submitting changes
- Code standards
- Testing requirements

## Documentation

- [Installation Guide](docs/INSTALLATION_GUIDE.md)
- [Contributing Guide](CONTRIBUTING.md)
- [README](README.md)

## Support

- Issues: Open an issue in this repository
- Questions: Use GitHub Discussions
- OpenShift docs: https://docs.openshift.com/

## License

MIT License - See LICENSE file for details

## Authors

Infrastructure Team

## Changelog

### v1.0.0 - Initial Release
- Complete Ansible repository structure
- OpenShift 4.x installation automation
- 3 master + 3 worker cluster support
- Prerequisites verification
- Post-installation configuration
- Comprehensive documentation
