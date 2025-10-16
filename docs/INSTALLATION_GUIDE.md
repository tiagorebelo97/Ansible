# OpenShift Installation Guide

This guide provides detailed steps for installing OpenShift using this Ansible repository.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Network Requirements](#network-requirements)
3. [Installation Steps](#installation-steps)
4. [Troubleshooting](#troubleshooting)
5. [Post-Installation](#post-installation)

## Prerequisites

### Hardware Requirements

#### Master Nodes (3 required)
- CPU: 4 vCPUs minimum
- Memory: 16 GB RAM minimum
- Storage: 120 GB minimum
- Network: 1 Gbps

#### Worker Nodes (3 required)
- CPU: 2 vCPUs minimum (8 recommended)
- Memory: 8 GB RAM minimum (32 GB recommended)
- Storage: 120 GB minimum (200 GB recommended)
- Network: 1 Gbps

#### Bootstrap Node (1 temporary)
- CPU: 4 vCPUs
- Memory: 16 GB RAM
- Storage: 120 GB
- Network: 1 Gbps

### Software Requirements

- RHEL 8.x or 9.x (or compatible: CentOS Stream, Rocky Linux, AlmaLinux)
- SSH access to all nodes
- Python 3.6+ on all nodes
- Ansible 2.15+ on control node

### Network Requirements

#### Required Ports

**All Nodes:**
- 22/tcp - SSH

**Control Plane (Masters):**
- 6443/tcp - Kubernetes API
- 2379-2380/tcp - etcd server client API
- 10250/tcp - Kubelet API
- 10251/tcp - kube-scheduler
- 10252/tcp - kube-controller-manager

**Workers:**
- 10250/tcp - Kubelet API
- 30000-32767/tcp - NodePort Services

**All Nodes (overlay network):**
- 4789/udp - VXLAN
- 6081/udp - Geneve
- 9000-9999/tcp - Host level services (node exporter, etc.)

## Installation Steps

### Step 1: Prepare Control Node

```bash
# Clone repository
git clone <repository-url>
cd Ansible

# Run setup
./setup.sh
```

### Step 2: Configure Variables

Edit `inventory/hosts.yml` with your node IP addresses.

Edit `inventory/group_vars/openshift.yml` with your cluster configuration.

### Step 3: Verify Prerequisites

```bash
make verify
```

### Step 4: Install OpenShift

```bash
make deploy
```

### Step 5: Post-Installation

```bash
make post-install
```

For detailed instructions, see the full documentation.
