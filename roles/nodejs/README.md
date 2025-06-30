# Ansible Role: nodejs

Install Node.js and npm from system repositories on Debian-based systems.

## Description

This role installs Node.js and npm using the system package manager (apt) on Debian 12+ and Ubuntu 24.04+ systems. It provides a clean, system-integrated installation and integrates with the collection's metadata system.

## Requirements

- **Operating System**: Debian 12+ or Ubuntu 24.04+
- **Architecture**: amd64 or arm64
- **Ansible**: 2.16+
- **Privileges**: sudo access for package installation

## System Package Versions

This role installs Node.js from system repositories:

- **Debian 12 (bookworm)**: Node.js 18.19.0
- **Ubuntu 24.04 LTS (noble)**: Node.js 18.19.1

Both versions meet the minimum Node.js 18+ requirement for modern applications.

## Role Variables

### Public Variables (defaults/main.yml)

```yaml
# Enable/disable Node.js installation
nodejs_install: true

# Minimum Node.js version required
nodejs_minimum_version: "18"
```

### Private Variables (vars/main.yml)

```yaml
# System packages to install
nodejs__packages:
  - nodejs
  - npm

# Supported architectures
nodejs__supported_architectures:
  - amd64
  - arm64

# Metadata files created
nodejs__metadata_files:
  - nodejs-version
  - npm-version
```

## Dependencies

None.

## Example Playbook

### Basic Installation

```yaml
- hosts: servers
  become: true
  roles:
    - adaptivegears.actions.nodejs
```

### Custom Configuration

```yaml
- hosts: servers
  become: true
  vars:
    nodejs_minimum_version: "18"
  roles:
    - adaptivegears.actions.nodejs
```

### Conditional Installation

```yaml
- hosts: servers
  become: true
  vars:
    nodejs_install: "{{ install_development_tools | default(false) }}"
  roles:
    - adaptivegears.actions.nodejs
```

## Features

### Intelligent Installation
- Checks if adequate Node.js version already exists
- Only installs if necessary (version < minimum requirement)
- Graceful handling of existing installations

### Error Handling
- Validates system requirements before installation
- Provides meaningful error messages

## Usage with npm Global Packages

After role execution, you can install global npm packages:

```bash
# Install global packages (requires sudo for system-wide installation)
sudo npm install -g @anthropic-ai/claude-code

# Verify global packages
npm list -g --depth=0
```

## Troubleshooting

### Permission Issues with npm
If you encounter permission issues with npm global installs:

1. Use sudo for global package installation:
   ```bash
   sudo npm install -g package-name
   ```

2. For user-specific installations, consider using a Node.js version manager like nvm

### Node.js Version Issues
If the installed Node.js version is inadequate:

1. Check available system version:
   ```bash
   apt show nodejs
   ```

2. For newer versions, consider using NodeSource repository
3. Update the `nodejs_minimum_version` variable if needed

### Architecture Issues
Supported architectures: amd64, arm64

For other architectures, you may need to modify `nodejs__supported_architectures` in vars/main.yml.

## License

MIT

## Author Information

This role was created by Adaptive Gears as part of the `adaptivegears.actions` Ansible collection.