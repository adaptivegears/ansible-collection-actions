# Kubernetes Role

This role provides comprehensive Kubernetes cluster management with support for both control plane initialization and node joining functionality.

## Features

- **Multi-role support**: Control plane initialization and worker node joining
- **Metadata integration**: Leverages the collection's metadata system for configuration
- **Container runtime**: Automated containerd setup with proper CRI configuration
- **Network configuration**: Configurable pod and service subnets with topology awareness
- **Security**: Automatic package holds and secure credential management
- **Idempotency**: Safe to run multiple times without side effects

## Role Variables

### Node Role Configuration

```yaml
# Node role - determines behavior (control-plane or worker)
kubernetes_role: "control-plane"  # Default: control-plane
```

### Cluster Configuration

```yaml
# Cluster settings
kubernetes_name: "kubernetes"
kubernetes_subnet_pod: "10.100.0.0/16"
kubernetes_subnet_service: "10.110.0.0/16"
```

### Join Configuration (for worker nodes)

```yaml
# Join credentials (automatically managed via metadata system)
kubernetes_join_token: ""                    # Bootstrap token for joining
kubernetes_join_discovery_hash: ""           # CA certificate hash for discovery
kubernetes_join_endpoint: ""                 # Control plane endpoint (IP:port)
kubernetes_join_certificate_key: ""          # Certificate key for control plane joins
```

### Metadata Integration

The role integrates with the collection's metadata system using the standard fallback pattern:

```yaml
variable: >-
  {{
    (
      lookup('env', 'VARIABLE_NAME') or
      lookup('file', '/var/lib/instance-metadata/variable-name', errors='ignore') or
      default_value
    ) | trim
  }}
```

## Usage Examples

### Control Plane Initialization

```yaml
- hosts: control-plane-nodes
  become: true
  roles:
    - role: debian  # Required dependency
    - role: kubernetes
      vars:
        kubernetes_role: "control-plane"
        kubernetes_name: "production-cluster"
```

### Worker Node Joining

```yaml
- hosts: worker-nodes
  become: true
  roles:
    - role: debian  # Required dependency
    - role: kubernetes
      vars:
        kubernetes_role: "worker"
        kubernetes_join_token: "{{ control_plane_join_token }}"
        kubernetes_join_discovery_hash: "{{ control_plane_discovery_hash }}"
        kubernetes_join_endpoint: "{{ control_plane_ip }}:6443"
```

### Multi-Node Cluster Setup

```yaml
# First, initialize control plane
- hosts: control-plane
  become: true
  roles:
    - role: debian
    - role: kubernetes
      vars:
        kubernetes_role: "control-plane"

# Then join worker nodes
- hosts: workers
  become: true
  roles:
    - role: debian
    - role: kubernetes
      vars:
        kubernetes_role: "worker"
        kubernetes_join_token: "{{ hostvars[groups['control-plane'][0]]['kubernetes_join_token'] }}"
        kubernetes_join_discovery_hash: "{{ hostvars[groups['control-plane'][0]]['kubernetes_join_discovery_hash'] }}"
        kubernetes_join_endpoint: "{{ hostvars[groups['control-plane'][0]]['kubernetes_join_endpoint'] }}"
```

### Environment Variable Configuration

```bash
# Set node role
export KUBERNETES_ROLE=worker

# Set join credentials
export KUBERNETES_JOIN_TOKEN=abcdef.0123456789abcdef
export KUBERNETES_JOIN_DISCOVERY_HASH=sha256:abcd1234...
export KUBERNETES_JOIN_ENDPOINT=10.0.0.10:6443
```

## Metadata System Integration

### Stored Metadata Files

The role creates and manages these metadata files:

```
/var/lib/instance-metadata/
├── kubernetes-role                           # Node role (control-plane/worker)
├── kubernetes-join-endpoint                  # Cluster endpoint for joining
└── auth/                                     # Secure credential storage (0500)
    ├── kubernetes-join-token                 # Bootstrap token (0400)
    ├── kubernetes-join-discovery-hash        # CA cert hash (0400)
    └── kubernetes-join-certificate-key       # Control plane cert key (0400)
```

### Automatic Credential Generation

Control plane nodes automatically generate join credentials:

- **Bootstrap tokens**: Created with 24-hour TTL
- **Discovery hashes**: Generated from cluster CA certificate
- **Certificate keys**: Created for additional control plane nodes
- **Endpoints**: Automatically determined from node IP addresses

## Dependencies

- **debian role**: Must be applied first for system preparation
- **Container runtime**: containerd (automatically installed)
- **Network requirements**: Ports 6443 (API server) and 10250 (kubelet)

## Supported Platforms

- Debian 12 (Bookworm)
- Ubuntu 22.04 LTS and later (via debian role compatibility)

## Testing

### Single Node Testing

```bash
# Test control plane initialization
make test-kubernetes

# Test with VM environment
make vm-reset
ansible-playbook tests/playbooks/debian12-kubernetes.yml
```

### Multi-Node Testing

```bash
# Test join functionality
ansible-playbook tests/playbooks/debian12-kubernetes-join.yml
```

## Security Considerations

- Join tokens are stored with 0400 permissions
- Bootstrap tokens have 24-hour TTL by default
- Package holds prevent accidental upgrades
- Certificate keys are regenerated for each control plane join

## Troubleshooting

### Common Issues

1. **Join token expired**: Tokens expire after 24 hours
   ```bash
   # Generate new token on control plane
   kubeadm token create --ttl 24h
   ```

2. **Discovery hash mismatch**: CA certificate changed
   ```bash
   # Get current hash on control plane
   openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \
   openssl rsa -pubin -outform der 2>/dev/null | \
   openssl dgst -sha256 -hex | sed 's/^.* /sha256:/'
   ```

3. **Network connectivity**: Ensure control plane endpoint is reachable
   ```bash
   # Test connectivity to control plane
   telnet <control-plane-ip> 6443
   ```

### Logs and Diagnostics

```bash
# Check kubelet logs
journalctl -u kubelet -f

# Check containerd logs
journalctl -u containerd -f

# Verify cluster status
kubectl get nodes -o wide
kubectl get pods --all-namespaces
```

## Version Information

- **Kubernetes**: 1.31.3
- **containerd**: Latest stable
- **CNI Plugins**: Latest stable
- **Pause Image**: registry.k8s.io/pause:3.10