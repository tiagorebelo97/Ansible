# Ansible Infrastructure as Code Repository

This repository contains Ansible automation for Infrastructure as Code (IaC), including OpenShift cluster installation and management.

## Repository Structure

```
.
├── ansible.cfg                 # Ansible configuration
├── requirements.yml            # Ansible collections and roles dependencies
├── inventory/                  # Inventory definitions
│   ├── hosts.yml              # Main inventory file (3 masters + 3 workers)
│   └── group_vars/            # Group-specific variables
│       ├── openshift.yml      # OpenShift cluster variables
│       ├── masters.yml        # Master nodes configuration
│       └── workers.yml        # Worker nodes configuration
├── playbooks/                  # Ansible playbooks
│   ├── install-openshift.yml  # Main OpenShift installation playbook
│   ├── verify-prerequisites.yml  # Prerequisites verification
│   └── post-install-config.yml   # Post-installation configuration
├── roles/                      # Ansible roles
│   ├── common/                # Common configuration for all nodes
│   ├── prerequisites/         # OpenShift prerequisites
│   ├── bootstrap/             # Bootstrap node configuration
│   ├── master/                # Master nodes configuration
│   ├── worker/                # Worker nodes configuration
│   └── finalize/              # Finalization tasks
├── group_vars/                # Global group variables
├── host_vars/                 # Host-specific variables
├── files/                     # Static files
└── templates/                 # Jinja2 templates
```

## Prerequisites

### Software Requirements
- Ansible 2.15 or higher
- Python 3.8+
- Required Ansible collections (installed via requirements.yml)

### Infrastructure Requirements
- 7 servers total:
  - 1 bootstrap node (temporary, can be removed after installation)
  - 3 master nodes (minimum 4 vCPUs, 16GB RAM, 120GB disk)
  - 3 worker nodes (minimum 2 vCPUs, 8GB RAM, 120GB disk)
- RHEL 8+ or compatible OS (CentOS, Rocky, AlmaLinux)
- Network connectivity between all nodes
- DNS resolution configured
- Load balancer for API and Ingress (external)

## Quick Start

### 1. Install Dependencies

```bash
# Install required Ansible collections
ansible-galaxy collection install -r requirements.yml

# Or install manually
pip install ansible
```

### 2. Configure Inventory

Edit `inventory/hosts.yml` to match your environment:

```yaml
# Update IP addresses for your nodes
master01:
  ansible_host: 10.0.0.11  # Change to your master01 IP
  # ... etc
```

### 3. Configure Variables

Edit `inventory/group_vars/openshift.yml`:

```yaml
cluster_name: "ocp-cluster"          # Your cluster name
base_domain: "example.com"           # Your base domain
openshift_version: "4.14"            # OpenShift version
ssh_public_key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
```

### 4. Verify Prerequisites

```bash
ansible-playbook playbooks/verify-prerequisites.yml
```

### 5. Install OpenShift

```bash
ansible-playbook playbooks/install-openshift.yml
```

### 6. Post-Installation Configuration

```bash
# Set KUBECONFIG environment variable
export KUBECONFIG=/path/to/auth/kubeconfig

# Run post-installation tasks
ansible-playbook playbooks/post-install-config.yml
```

## OpenShift Installation Process

The installation process is divided into several phases:

### Phase 1: Common Configuration
- Sets hostname and updates /etc/hosts
- Disables swap
- Configures timezone and SELinux
- Installs required packages
- Configures NTP

### Phase 2: Prerequisites
- Loads kernel modules (overlay, br_netfilter)
- Sets sysctl parameters for Kubernetes
- Configures firewall rules
- Installs and configures CRI-O container runtime
- Installs OpenShift client tools (oc, kubectl)

### Phase 3: Bootstrap
- Downloads OpenShift installer
- Prepares for ignition config generation
- Sets up bootstrap node

### Phase 4: Master Nodes
- Configures etcd firewall rules
- Prepares master nodes for cluster joining
- Sets up master-specific configurations

### Phase 5: Worker Nodes
- Configures worker-specific firewall rules
- Prepares worker nodes for cluster joining
- Verifies disk space requirements

### Phase 6: Finalization
- Waits for API server availability
- Displays cluster access information
- Creates cluster info documentation

## Available Playbooks

### install-openshift.yml
Main playbook for OpenShift cluster installation across all nodes.

```bash
ansible-playbook playbooks/install-openshift.yml
```

### verify-prerequisites.yml
Verifies that all nodes meet the minimum requirements for OpenShift installation.

```bash
ansible-playbook playbooks/verify-prerequisites.yml
```

### post-install-config.yml
Performs post-installation configuration and verification.

```bash
ansible-playbook playbooks/post-install-config.yml
```

## Roles Description

### common
Base configuration applied to all nodes including hostname, timezone, NTP, and basic packages.

### prerequisites
Installs and configures OpenShift prerequisites including CRI-O runtime, kernel modules, and sysctl settings.

### bootstrap
Configures the bootstrap node and prepares OpenShift installer.

### master
Configures master nodes with etcd and control plane requirements.

### worker
Configures worker nodes for running application workloads.

### finalize
Finalizes installation and provides cluster access information.

## Cluster Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Load Balancer                         │
│              (API: 6443, Ingress: 80/443)               │
└─────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
┌───────▼────────┐ ┌────────▼───────┐ ┌────────▼───────┐
│   Master 01    │ │   Master 02    │ │   Master 03    │
│  10.0.0.11     │ │  10.0.0.12     │ │  10.0.0.13     │
│  4 vCPU/16GB   │ │  4 vCPU/16GB   │ │  4 vCPU/16GB   │
└────────────────┘ └────────────────┘ └────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
┌───────▼────────┐ ┌────────▼───────┐ ┌────────▼───────┐
│   Worker 01    │ │   Worker 02    │ │   Worker 03    │
│  10.0.0.21     │ │  10.0.0.22     │ │  10.0.0.23     │
│  8 vCPU/32GB   │ │  8 vCPU/32GB   │ │  8 vCPU/32GB   │
└────────────────┘ └────────────────┘ └────────────────┘
```

## Accessing the Cluster

After installation, access your cluster using:

```bash
# Set KUBECONFIG
export KUBECONFIG=/path/to/auth/kubeconfig

# Login
oc login https://api.ocp-cluster.example.com:6443

# View nodes
oc get nodes

# View cluster operators
oc get co

# View all pods
oc get pods -A
```

## Web Console

Access the OpenShift web console at:
```
https://console-openshift-console.apps.ocp-cluster.example.com
```

## Troubleshooting

### Check Ansible connectivity
```bash
ansible all -m ping
```

### Verify prerequisites
```bash
ansible-playbook playbooks/verify-prerequisites.yml
```

### Check cluster operators status
```bash
oc get co
```

### View installation logs
```bash
tail -f ansible.log
```

### Check node status
```bash
oc get nodes
oc describe node <node-name>
```

## Maintenance

### Adding Worker Nodes
To scale the cluster by adding more worker nodes:

1. Add new nodes to `inventory/hosts.yml`
2. Run the playbook with the `workers` tag:
   ```bash
   ansible-playbook playbooks/install-openshift.yml --tags workers --limit <new-worker-node>
   ```

### Upgrading OpenShift
Update the `openshift_version` variable in `inventory/group_vars/openshift.yml` and follow OpenShift upgrade procedures.

## Security Considerations

- Store sensitive data in Ansible Vault
- Use SSH keys for authentication
- Configure firewall rules appropriately
- Regularly update OpenShift and OS packages
- Review and apply security benchmarks

## Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

MIT

## Support

For issues and questions, please open an issue in this repository.