# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## POLICY

### NEVER DO THIS
- NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.
- NEVER break the established directory structure
- NEVER force push to the main branch

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
make vm-up                 # Start test VM
make vm-destroy            # Stop test VM

# Multi-node cluster testing workflow
make vm-cluster-up         # Start both control plane and worker VMs
make vm-cluster-reset      # Complete multi-node reset: destroy, create, test connectivity

# Role testing
make test-ansible-role-apt        # Run APT role test against VM
make test-ansible-role-debian     # Run debian role test with purge functionality
make test-ansible-role-ssh       # Run SSH role test with security validation
make test-ansible-role-kubernetes # Run consolidated kubernetes role test
make test-tailscale              # Run Tailscale role test

# Manual testing
ansible node1 -m ping      # Test VM connectivity
ansible-lint roles/<role>  # Lint specific role
```

### Available Roles
- `debian` - Base Debian 12 system (400+ packages)
- `apt` - APT package management and repository configuration
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
   - Use descriptive commit messages
   - **CRITICAL**: Before committing, validate changes for functional errors:
     - Verify YAML syntax is valid
     - Ensure variable references are correct
     - Test that role dependencies are intact

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
- Reference related issues if applicable
- Keep commits focused and atomic

### Pull Request Approval Process
**IMPORTANT**: When the user says a PR is "approved", automatically proceed with the GitHub flow merge process:

1. **Automatic Merge on Approval**: When user confirms PR approval (using words like "approved", "merge", "process on gh flow"), immediately execute:
   ```bash
   gh pr merge <PR_NUMBER> --squash --delete-branch
   ```

2. **Post-Merge Verification**: After merge, verify:
   - Merge completed successfully
   - Branch was deleted
   - Switch back to main branch and pull latest changes

3. **No Manual Confirmation Required**: Do not ask for additional confirmation when user has already approved - proceed directly with merge.

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
- Resources: 2GB RAM, 2 CPUs per VM
- Single VM: IP 192.168.56.10 (node1)
- Multi-node cluster:
  - Control plane: IP 192.168.56.10 (node1)
  - Worker node: IP 192.168.56.11 (node2)
- Requirements: VMware Fusion, Vagrant with vagrant-vmware-desktop plugin

**VM Management Commands:**
```bash
# Single VM workflow
make vm-reset              # Destroy → create → test connectivity
make vm-up                 # Start VM
make vm-destroy            # Stop VM

# Multi-node cluster workflow
make vm-cluster-reset      # Destroy → create both VMs → test connectivity
make vm-cluster-up         # Start both control plane and worker VMs

# VM access
cd tests/vm && vagrant ssh node1   # Connect to control plane
cd tests/vm && vagrant ssh node2   # Connect to worker node
```

**Testing Configuration:**
- **Ansible Config**: `tests/ansible.cfg` (optimized for VM testing)
- **Inventory**: `tests/inventory` (VM connection details)
- **Environment**: `.envrc` sets `ANSIBLE_CONFIG` automatically

### Test Playbooks
Located in `tests/playbooks/` with pattern `ansible-role-{role}.yml`:

```bash
# Role tests
ansible-playbook tests/playbooks/ansible-role-apt.yml
ansible-playbook tests/playbooks/ansible-role-debian.yml
ansible-playbook tests/playbooks/ansible-role-ssh.yml
ansible-playbook tests/playbooks/ansible-role-kubernetes.yml    # Consolidated multi-node test
ansible-playbook tests/playbooks/ansible-role-tailscale.yml

# Run with options
ansible-playbook tests/playbooks/ansible-role-apt.yml -v               # Verbose
ansible-playbook tests/playbooks/ansible-role-apt.yml -e "var=value"   # Extra vars
```

### Testing Use Cases
1. **Role Development**: Test roles against clean Debian 12 environment using standardized node1/node2 hostnames
2. **Playbook Validation**: Verify playbooks work before deployment
3. **Metadata System Testing**: Validate `/var/lib/instance-metadata/` functionality
4. **Integration Testing**: Test role interactions and dependencies
5. **Package Installation**: Verify 400+ package installations in debian role
6. **Multi-node Cluster Testing**: Consolidated kubernetes role test handles both single-node and multi-node scenarios
7. **Security Validation**: SSH role includes comprehensive security configuration testing

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
├── kubernetes-role           # Kubernetes node role (control-plane/worker)
├── kubernetes-join-endpoint  # Kubernetes cluster endpoint
├── kubernetes-join-token     # Bootstrap token for cluster joining (0400)
├── kubernetes-join-discovery-hash # CA certificate hash (0400)
├── kubernetes-join-certificate-key # Certificate key for control plane (0400)
└── auth/                     # Legacy authentication tokens (0500 permissions)
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
- **Variable naming**:
  - **Public variables**: Use single underscore prefix (e.g., `kubernetes_role`, `kubernetes_join_token`)
  - **Private variables**: Use double underscore prefix, avoid redundant suffixes (e.g., `kubernetes__bootstrap_token`, `kubernetes__containerd_config`)
  - **Metadata files**: Use role prefix with hyphen separator (e.g., `kubernetes-join-token`, `kubernetes-role`)
  - **Descriptive naming**: Use clear, descriptive names for boolean checks (e.g., `ssh__iptables_present` not `ssh__iptables_available`)

### System Dependencies and Conditional Logic
- **Never force-install system packages**: Check availability before use, don't automatically install system tools like `iptables`, `ufw`, etc.
- **Graceful degradation**: When optional tools are unavailable, skip functionality silently rather than failing
- **Availability checks**: Use `which` command with `failed_when: false` to check tool presence
- **Conditional blocks**: Group related tasks that depend on system tools using `when` conditions

```yaml
# Good: Check before use
- name: Check if iptables is available
  ansible.builtin.command: which iptables
  register: ssh__iptables_present
  failed_when: false
  changed_when: false

- name: Configure firewall rules
  when: ssh__iptables_present.rc == 0
  block:
    - name: Add iptables rule
      ansible.builtin.iptables: ...
```

### Code Quality Standards
- **No unnecessary debug output**: Avoid `ansible.builtin.debug` tasks unless specifically needed for troubleshooting
- **Shell command safety**: Always use `set -o pipefail` in shell commands with pipes to meet lint requirements
- **Error handling**: Use `failed_when: false` for commands that may legitimately fail
- **Idempotency**: Ensure all tasks can be run multiple times safely with `changed_when` directives

### Role Design Principles
- **Trust your tools**: Don't add redundant verification steps if the underlying module (like `apt`) already provides error handling
- **Simplicity over complexity**: Avoid unnecessary configuration variables and verification steps that don't add real value
- **Focus on core purpose**: Keep roles focused on their primary function rather than adding peripheral features
- **Test in tests, not roles**: Verification belongs in test playbooks, not in the role implementation itself

### Metadata System Guidelines
- **Use sparingly**: Only implement metadata for complex inter-role communication (e.g., cluster tokens, shared state)
- **Avoid for simple installations**: Foundation roles (runtime installations like Node.js, Python) don't need metadata tracking
- **Direct system checks preferred**: Use `which command` or `command --version` instead of reading potentially stale metadata files
- **When to skip metadata**: If the role is idempotent through direct system state checking, metadata is unnecessary

### Variable Design Best Practices
- **Minimize configuration options**: Only expose variables that provide genuine value to users
- **Remove redundant variables**: If a variable doesn't change behavior meaningfully, eliminate it
- **Example of good simplification**: Remove `nodejs_verify_installation` - verification should happen in tests, not roles
