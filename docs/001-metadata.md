# EP-001: Metadata

## Summary
A standardized system for storing and managing instance-specific metadata on Debian systems. This proposal defines a consistent structure for storing various types of instance metadata including network information, topology data, authentication tokens, and system identifiers.

## Motivation
Instance metadata is crucial for system operations, but it's often scattered across different locations or stored inconsistently. A centralized, standardized metadata storage system would improve system management, service discovery, and operational consistency.

Ansible's stateless design, while promoting idempotency and simplicity, presents several operational challenges:

1. State Persistence:
   - Ansible doesn't maintain state between playbook runs
   - Variable values are lost after playbook completion
   - Default values may not always be suitable or available
   - Need to persist decisions made during previous runs

2. Inter-role Communication:
   - No built-in mechanism for roles to share data
   - Different roles might need access to the same information
   - Role dependencies become harder to manage without shared state

3. System Integration:
   - Need for simple integration with both Ansible and external tools
   - Complex solutions like Consul or etcd add unnecessary overhead
   - File-based approach provides universal accessibility
   - Standard Unix file permissions provide security model

### Goals
- Define a standardized directory structure for instance metadata
- Provide persistent storage for Ansible-managed data
- Enable data sharing between different Ansible roles
- Create predictable fallback mechanisms for missing playbook arguments
- Establish consistent locations for instance-specific data
- Support both Ansible and non-Ansible tools access

### Non-Goals
- Implementing metadata synchronization between instances
- Creating a metadata API service
- Managing application-specific configurations
- Providing metadata backup solutions
- Implementing metadata encryption at rest

## Proposal

1. Directory Structure:
   ```
   /var/lib/instance-metadata/
   ├── hostname                   # System hostname (0644)
   ├── ipv4-private               # Private IPv4 address (0644)
   ├── ipv4-public                # Public IPv4 address if available (0644)
   ├── ipv4-public-egress         # Outbound public IPv4 (0644)
   ├── ipv4-public-ingress        # Inbound public IPv4 if NAT traversal possible (0644)
   ├── topology-region            # Geographic region identifier (0644)
   ├── topology-zone              # Availability zone identifier (0644)
   └── auth/                      # Authentication tokens directory (0500)
       └── tailscale-authkey      # Tailscale auth key (0400)
   ```

2. Usage Patterns:

   a. Fallback Chain:
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

   b. Inter-role Data Sharing:
   ```yaml
   # Role A: Write data
   - name: Store data for other roles
     ansible.builtin.copy:
       content: "{{ some_variable }}"
       dest: /var/lib/instance-metadata/shared-data
       mode: "0644"

   # Role B: Read data
   - name: Read data from other role
     ansible.builtin.set_fact:
       shared_variable: "{{ lookup('file', '/var/lib/instance-metadata/shared-data') }}"
   ```

3. Implementation Principles:
   - Use atomic file operations
   - Implement consistent permission model
   - Provide clear file naming convention
   - Maintain simple, flat file structure
   - Use predictable file formats

## Drawbacks

1. Filesystem Limitations:
   - No built-in versioning
   - Limited to local storage

2. Management Overhead:
   - Manual cleanup required
   - No automatic expiration
   - Potential for stale data
   - Directory permissions management

3. Scalability Constraints:
   - Limited to single instance
   - No built-in replication
   - Manual synchronization needed
   - Local access only
