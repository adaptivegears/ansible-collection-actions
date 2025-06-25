# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the `adaptivegears.actions` Ansible Collection - a structured package of automation content for infrastructure provisioning and server management, specifically focused on Debian-based systems. The collection provides standardized roles, playbooks, and a metadata management system for consistent server deployments across cloud providers.

## Development Commands

### Essential Commands
- `make help` - Show all available make targets
- `make test` - Run molecule tests on all roles (uses QEMU virtualization)
- `make format` - Format code using ansible-lint
- `make build` - Build collection archive (runs format first)
- `make install` - Install collection locally (builds first)
- `make clean` - Remove build artifacts

### Testing Individual Roles
- `cd roles/<role-name> && molecule test` - Test a specific role
- Available roles: `linux/debian`, `ssh`, `tailscale`, `kubernetes`, `metadata`

### Python Environment
- Uses pipenv for dependency management
- `pipenv install` - Install dependencies
- `pipenv shell` - Activate virtual environment
- Requires Python 3.11, Ansible ~=10.0

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

## Testing Framework

Uses Molecule with QEMU virtualization for role testing:
- Test configurations in each role's `molecule/` directory
- QEMU-based virtual machines for testing
- pytest-testinfra for validation
- Molecule version constraint: `<7.0.0,>=6.0.0`

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
- Build dependencies: ansible-lint, molecule, pytest-testinfra