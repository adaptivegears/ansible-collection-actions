# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the `adaptivegears.actions` Ansible Collection - a structured package of automation content for infrastructure provisioning and server management, specifically focused on Debian-based systems. The collection provides standardized roles, playbooks, and a metadata management system for consistent server deployments across cloud providers.

## Development Commands

### Essential Commands
- `make help` - Show all available make targets
- `make test` - Run lint checks on all roles
- `make format` - Format code using ansible-lint
- `make build` - Build collection archive (runs format first)
- `make install` - Install collection locally (builds first)
- `make clean` - Remove build artifacts

### Testing Individual Roles
- `ansible-lint roles/<role-name>` - Lint a specific role
- Available roles: `linux/debian`, `ssh`, `tailscale`, `kubernetes`, `metadata`

### Development Environment
- Uses direnv + pipenv for environment management
- `direnv allow` - Allow .envrc to load automatically (first time only)
- Environment activates automatically when entering directory
- `pipenv install` - Install dependencies (if needed)
- Requires Python 3.11, Ansible ~=10.0, direnv installed

### Local Testing with Vagrant
- **VM Setup**: `cd tests/vm && vagrant up` - Start Debian 12 VM for testing
- **VM Access**: `vagrant ssh` - Connect to test VM
- **VM Management**: `vagrant halt` / `vagrant destroy -f` - Stop/remove VM
- **Requirements**: VMware Fusion, Vagrant with vagrant-vmware-desktop plugin
- **VM Specs**: Debian 12 (bento/debian-12), 2GB RAM, 2 CPUs, IP 192.168.56.10

### Testing Configuration
The project includes a centralized testing configuration:
- **Ansible Config**: `tests/ansible.cfg` - Optimized settings for VM testing
- **Environment**: `.envrc` sets `ANSIBLE_CONFIG` to use test configuration automatically
- **Inventory**: `tests/inventory` - VM connection details with Python3 interpreter
- **Makefile**: `tests/Makefile` - Testing automation commands

### Testing Commands
- `ansible debian12 -m ping` - Test connectivity (works from project root)
- `cd tests && make vm-up` - Start VM using Makefile
- `cd tests && make test-connectivity` - Test Ansible connection

### Test Playbooks
Located in `tests/playbooks/` directory with naming pattern `debian12-{role}.yml`:
- `tests/playbooks/debian12-apt.yml` - Test APT role configuration and package management

#### Running Test Playbooks
```bash
# Run specific test playbook
ansible-playbook tests/playbooks/debian12-apt.yml

# Run with verbose output
ansible-playbook tests/playbooks/debian12-apt.yml -v

# Run with extra variables
ansible-playbook tests/playbooks/debian12-apt.yml -e "variable=value"
```

### VM Testing Use Cases
1. **Role Development**: Test individual roles against clean Debian 12 environment
2. **Playbook Validation**: Verify playbooks work on actual system before deployment  
3. **Metadata System Testing**: Validate `/var/lib/instance-metadata/` functionality
4. **Integration Testing**: Test role interactions and dependencies
5. **Package Installation**: Verify 400+ package installations in linux/debian role

## Architecture Overview

### Core Innovation: Metadata System
The collection implements a filesystem-based metadata storage system at `/var/lib/instance-metadata/` that addresses Ansible's stateless nature:

- **State Persistence**: Variables and decisions persist between playbook runs
- **Inter-role Communication**: Roles can share data through standardized file locations
- **Fallback Chains**: Supports environment variables → metadata files → defaults pattern
- **Topology Awareness**: Stores provider/region/zone information for location-aware operations

### Role Structure
Each role follows a numbered task organization pattern:
- `000-prerequisites.yml` - Setup and validation
- `1XX-` prefix - Main functionality tasks
- `2XX-` prefix - Configuration tasks  
- `3XX-` prefix - Advanced/optional tasks
- `999-metadata.yml` - Metadata storage (where applicable)

### Key Roles
- **linux/debian**: Base Debian 12 system with 400+ packages (kernel, hardware, networking, security)
- **ssh**: SSH server hardening and access control
- **tailscale**: VPN mesh networking setup
- **kubernetes**: Container orchestration platform components
- **metadata**: Cross-role state management and topology metadata

### Playbook Patterns
Standard playbooks in `/playbooks/` directory:
- `standard-debian.yml` - Base server setup
- `standard-ssh.yml` - SSH configuration
- `standard-tailscale.yml` - VPN setup
- `standard-kubernetes.yml` - K8s cluster setup

## Metadata System Implementation

### Directory Structure
```
/var/lib/instance-metadata/
├── hostname                   # System hostname
├── ipv4-private              # Private IPv4 address
├── ipv4-public               # Public IPv4 address
├── topology-provider         # Cloud provider (aws, azure, gcp, etc.)
├── topology-region           # Provider region identifier
├── topology-zone             # Provider zone identifier
└── auth/                     # Authentication tokens (0500 permissions)
    └── tailscale-authkey     # Tailscale auth key (0400 permissions)
```

### Usage Pattern in Tasks
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

## Collection Management

### Galaxy Configuration
- Namespace: `adaptivegears`
- Collection name: `actions`
- Version: 1.0.0 (defined in galaxy.yml)
- Requires Ansible >=2.16

### Build and Release
- `GALAXY_API_KEY` environment variable required for publishing
- Build artifacts: `*.tar.gz` files
- Repository: https://github.com/adaptivegears/ansible-ansible-collections-actions

## Code Quality

Uses ansible-lint for code quality checks:
- Consistent code style and best practices
- Role validation and syntax checking
- Integrated with build process via `make format`

## Development Guidelines

### File Organization
- Tasks use numerical prefixes (000-, 100-, 200-, etc.) for execution order
- Each role has standardized directories: defaults/, tasks/, vars/, templates/, handlers/
- Documentation in role-specific README.md files
- Enhancement proposals in docs/ directory (EP-001, EP-002, etc.)

### Naming Conventions
- Task names use ">" separator (e.g., "Metadata > Topology")
- Topology identifiers: lowercase, alphanumeric with hyphens
- File permissions: 0644 for readable metadata, 0400/0500 for sensitive data

### Dependencies
- Collection has no external Ansible dependencies
- Python requirements managed via Pipfile
- Build dependencies: ansible-lint