# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## POLICY

### NEVER DO THIS
- NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.
- NEVER break the established directory structure

## QUICK REFERENCE

### Essential Daily Commands
```bash
# Development workflow
make help                    # Show all available commands
make lint                    # Run lint checks on all roles
make format                  # Format code using ansible-lint
make build                   # Build collection archive
make install                 # Install collection locally

# VM testing workflow
make vm-reset               # Complete test reset: destroy, create, test connectivity
make test                   # Run apt role test against VM
make test-debian           # Run debian role test with purge functionality
make vm-up                 # Start test VM
make vm-down               # Stop test VM

# Manual testing
ansible debian12 -m ping   # Test VM connectivity
ansible-lint roles/<role>  # Lint specific role
```

### Available Roles
- `linux/debian` - Base Debian 12 system (400+ packages)
- `ssh` - SSH server hardening and access control
- `tailscale` - VPN mesh networking setup
- `kubernetes` - Container orchestration components
- `metadata` - Cross-role state management and topology

## DEVELOPMENT WORKFLOW

### GitHub Flow Process
ALWAYS follow these steps when implementing changes:

1. **Start from main branch**:
   ```bash
   git checkout main
   git pull origin main
   ```

2. **Create feature branch**:
   ```bash
   git checkout -b feature/descriptive-name
   # Branch types: feature/, bugfix/, refactor/, docs/
   ```

3. **Make changes and commit**:
   - Follow existing code conventions
   - Run `make lint` before committing
   - Use descriptive commit messages

4. **Push and create pull request**:
   ```bash
   git push origin feature/descriptive-name
   gh pr create --title "Clear PR title" --body "Description" --assignee andreygubarev
   ```

5. **Wait for review and merge when approved**:
   ```bash
   gh pr merge --squash  # or --merge as appropriate
   ```

### Pull Request Requirements
- Assign to @andreygubarev
- Include clear title and description
- Ensure `make lint` passes
- Reference related issues if applicable
- Keep commits focused and atomic

### Development Environment Setup
- **Environment Manager**: direnv + pipenv
- **First-time setup**: `direnv allow` (enables automatic environment activation)
- **Dependencies**: Python 3.11, Ansible ~=10.0, direnv
- **Install dependencies**: `pipenv install` (if needed)

## TESTING & VALIDATION

### VM Testing with Vagrant
The project uses Vagrant with VMware Fusion for local testing:

**VM Specifications:**
- OS: Debian 12 (bento/debian-12)
- Resources: 2GB RAM, 2 CPUs
- Network: IP 192.168.56.10
- Requirements: VMware Fusion, Vagrant with vagrant-vmware-desktop plugin

**VM Management Commands:**
```bash
# Complete workflow
make vm-reset              # Destroy → create → test connectivity

# Individual operations
make vm-up                 # Start VM
make vm-down              # Stop VM
cd tests/vm && vagrant ssh # Connect to VM
```

**Testing Configuration:**
- **Ansible Config**: `tests/ansible.cfg` (optimized for VM testing)
- **Inventory**: `tests/inventory` (VM connection details)
- **Environment**: `.envrc` sets `ANSIBLE_CONFIG` automatically

### Test Playbooks
Located in `tests/playbooks/` with pattern `debian12-{role}.yml`:

```bash
# Run specific test playbooks
ansible-playbook tests/playbooks/debian12-apt.yml
ansible-playbook tests/playbooks/debian12-debian.yml

# Run with options
ansible-playbook tests/playbooks/debian12-apt.yml -v               # Verbose
ansible-playbook tests/playbooks/debian12-apt.yml -e "var=value"   # Extra vars
```

### Testing Use Cases
1. **Role Development**: Test roles against clean Debian 12 environment
2. **Playbook Validation**: Verify playbooks work before deployment
3. **Metadata System Testing**: Validate `/var/lib/instance-metadata/` functionality
4. **Integration Testing**: Test role interactions and dependencies
5. **Package Installation**: Verify 400+ package installations in linux/debian role

### Code Quality
- **Linting**: ansible-lint for code quality and best practices
- **Formatting**: Integrated with build process via `make format`
- **Individual role testing**: `ansible-lint roles/<role-name>`

## PROJECT ARCHITECTURE

### Overview
The `adaptivegears.actions` Ansible Collection provides structured automation content for infrastructure provisioning and server management, focused on Debian-based systems. It includes standardized roles, playbooks, and a filesystem-based metadata management system for consistent deployments across cloud providers.

### Core Innovation: Metadata System
Filesystem-based metadata storage at `/var/lib/instance-metadata/` addresses Ansible's stateless nature:

- **State Persistence**: Variables persist between playbook runs
- **Inter-role Communication**: Roles share data through standardized locations
- **Fallback Chains**: Environment variables → metadata files → defaults
- **Topology Awareness**: Cloud provider/region/zone information

**Directory Structure:**
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

**Usage Pattern:**
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

### Role Structure
Each role follows numbered task organization:
- `000-prerequisites.yml` - Setup and validation
- `1XX-` prefix - Main functionality tasks
- `2XX-` prefix - Configuration tasks
- `3XX-` prefix - Advanced/optional tasks
- `999-metadata.yml` - Metadata storage (where applicable)

### Standard Playbooks
Located in `/playbooks/` directory:
- `standard-debian.yml` - Base server setup
- `standard-ssh.yml` - SSH configuration
- `standard-tailscale.yml` - VPN setup
- `standard-kubernetes.yml` - K8s cluster setup

## COLLECTION MANAGEMENT

### Galaxy Configuration
- **Namespace**: `adaptivegears`
- **Collection**: `actions`
- **Version**: 1.0.0 (defined in galaxy.yml)
- **Ansible Version**: >=2.16 required
- **Repository**: https://github.com/adaptivegears/ansible-collection-actions

### Build and Release
```bash
make build                     # Build collection archive
make install                   # Install locally
make release                   # Publish (requires GALAXY_API_KEY)
```

- Build artifacts: `*.tar.gz` files
- No external Ansible dependencies
- Python dependencies managed via Pipfile

## DEVELOPMENT GUIDELINES

### File Organization
- **Task naming**: Numerical prefixes (000-, 100-, 200-) for execution order
- **Role structure**: Standardized directories (defaults/, tasks/, vars/, templates/, handlers/)
- **Documentation**: Role-specific README.md files
- **Enhancement proposals**: docs/ directory (EP-001, EP-002, etc.)

### Naming Conventions
- **Task names**: Use ">" separator (e.g., "Metadata > Topology")
- **Topology identifiers**: Lowercase, alphanumeric with hyphens
- **File permissions**: 0644 for readable metadata, 0400/0500 for sensitive data
- **Branch names**: `feature/description`, `bugfix/issue-description`, `refactor/component-name`, `docs/topic`