# Quick Reference Guide

## Common Commands

### Setup
```bash
./setup.sh              # Initial setup
make install            # Install dependencies
make ping               # Test connectivity
```

### Installation
```bash
make verify             # Verify prerequisites
make deploy             # Install OpenShift
make post-install       # Post-installation tasks
```

### Verification
```bash
make syntax             # Check playbook syntax
make check              # Dry-run installation
make inventory          # View inventory
```

### Maintenance
```bash
make clean              # Remove temporary files
make facts              # Gather node facts
```

## File Locations

### Configuration
- `ansible.cfg` - Ansible configuration
- `inventory/hosts.yml` - Node definitions
- `inventory/group_vars/openshift.yml` - Cluster configuration

### Playbooks
- `playbooks/install-openshift.yml` - Main installation
- `playbooks/verify-prerequisites.yml` - Prerequisites check
- `playbooks/post-install-config.yml` - Post-installation

### Documentation
- `README.md` - Main documentation
- `docs/INSTALLATION_GUIDE.md` - Installation guide
- `docs/PROJECT_OVERVIEW.md` - Project overview
- `CONTRIBUTING.md` - Contributing guidelines

## Important Variables

Edit `inventory/group_vars/openshift.yml`:
- `cluster_name` - Your cluster name
- `base_domain` - Your base domain
- `openshift_version` - OpenShift version
- `ssh_public_key` - SSH public key

Edit `inventory/hosts.yml`:
- Update IP addresses for all nodes

## Node Requirements

### Masters (3 nodes)
- 4 vCPUs, 16GB RAM, 120GB disk

### Workers (3 nodes)
- 8 vCPUs, 32GB RAM, 200GB disk

### Bootstrap (1 node, temporary)
- 4 vCPUs, 16GB RAM, 120GB disk

## Port Requirements

### All Nodes
- 22/tcp (SSH)

### Masters
- 6443/tcp (API)
- 2379-2380/tcp (etcd)
- 10250/tcp (Kubelet)

### Workers
- 10250/tcp (Kubelet)
- 30000-32767/tcp (NodePort)

## Quick Troubleshooting

### Can't connect to nodes
```bash
ansible all -m ping -vvv
ssh root@<node-ip>
```

### Prerequisites fail
```bash
ansible-playbook playbooks/verify-prerequisites.yml -vvv
```

### Installation issues
```bash
tail -f ansible.log
oc get co  # Check operators
oc get nodes  # Check nodes
```

## Useful OpenShift Commands

```bash
# Set kubeconfig
export KUBECONFIG=/path/to/auth/kubeconfig

# View nodes
oc get nodes

# View cluster operators
oc get co

# View all pods
oc get pods -A

# View cluster version
oc get clusterversion

# Access console
# https://console-openshift-console.apps.<cluster>.<domain>
```

## Architecture Diagram

```
Load Balancer (API: 6443, Ingress: 80/443)
    ↓
Master01, Master02, Master03 (Control Plane)
    ↓
Worker01, Worker02, Worker03 (Compute)
```

## Next Steps After Installation

1. Access web console
2. Create admin user
3. Configure storage
4. Install operators
5. Deploy applications

## Support

- Documentation: Check `docs/` folder
- Issues: Open GitHub issue
- OpenShift docs: https://docs.openshift.com/
