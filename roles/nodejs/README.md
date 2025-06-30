# Ansible Role: nodejs

Install Node.js and npm from system repositories on Debian-based systems.

## Description

This role installs Node.js and npm using the system package manager (apt) on Debian 12+ and Ubuntu 24.04+ systems. It provides a clean, system-integrated installation that follows security best practices and integrates with the collection's metadata system.

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

# Enable post-installation verification
nodejs_verify_installation: true

# Minimum Node.js version required
nodejs_minimum_version: "18"

# Configure npm global path to avoid permission issues
nodejs_configure_global_path: true

# npm global installation prefix
nodejs_global_prefix: "/usr/local"
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
    nodejs_global_prefix: "/opt/nodejs"
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

### npm Configuration
- Configures npm global prefix to avoid permission issues
- Sets up proper directory structure for global packages
- Verifies npm functionality post-installation

### Metadata Integration
- Stores Node.js version in `/var/lib/instance-metadata/nodejs-version`
- Stores npm version in `/var/lib/instance-metadata/npm-version`
- Stores npm global prefix in `/var/lib/instance-metadata/npm-global-prefix`

### Error Handling
- Validates system requirements before installation
- Verifies installation success
- Provides meaningful error messages

## Metadata Files

This role creates the following metadata files:

```
/var/lib/instance-metadata/
├── nodejs-version        # Node.js version (e.g., "v18.19.0")
├── npm-version          # npm version (e.g., "9.2.0")
└── npm-global-prefix    # Global prefix path (e.g., "/usr/local")
```

## Usage with npm Global Packages

After role execution, you can install global npm packages:

```bash
# Install global packages (no sudo required with proper configuration)
npm install -g @anthropic-ai/claude-code

# Verify global packages
npm list -g --depth=0
```

## Troubleshooting

### Permission Issues with npm
If you encounter permission issues with npm global installs:

1. Check npm configuration:
   ```bash
   npm config get prefix
   ```

2. Verify directory permissions:
   ```bash
   ls -la /usr/local/bin
   ```

3. Re-run the role with:
   ```yaml
   nodejs_configure_global_path: true
   ```

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