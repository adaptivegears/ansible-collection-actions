# EP-001: Metadata

## Summary
A standardized system for storing and managing instance-specific metadata on Debian systems. This proposal defines a consistent structure for storing various types of instance metadata including network information, topology data, authentication tokens, and system identifiers.

## Motivation
Instance metadata is crucial for system operations, but it's often scattered across different locations or stored inconsistently. A centralized, standardized metadata storage system would improve system management, service discovery, and operational consistency.

### Goals
- Define a standardized directory structure for instance metadata
- Establish consistent naming conventions and file permissions
- Support multiple metadata categories (network, topology, authentication, system)
- Provide atomic operations for metadata updates
- Ensure secure storage of sensitive metadata
- Enable easy metadata retrieval for other services
- Support both persistent and dynamic metadata

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
   ├── hostname                    # System hostname (0444)
   ├── ipv4-private               # Private IPv4 address (0644)
   ├── ipv4-public                # Public IPv4 address if available (0644)
   ├── ipv4-public-egress         # Outbound public IPv4 (0644)
   ├── ipv4-public-ingress        # Inbound public IPv4 if NAT traversal possible (0644)
   ├── topology-region            # Geographic region identifier (0644)
   ├── topology-zone              # Availability zone identifier (0644)
   └── auth/                      # Authentication tokens directory (0500)
       └── tailscale-authkey      # Tailscale auth key (0400)
   ```

2. File Categories and Permissions:
   - System Identifiers (0444):
     - hostname
   - Network Information (0644):
     - ipv4-private
     - ipv4-public*
   - Topology Data (0644):
     - topology-region
     - topology-zone
   - Authentication (0400):
     - auth/tailscale-authkey

3. Metadata Types:
   - Static: Rarely changes (hostname, topology)
   - Dynamic: May change during runtime (IP addresses)
   - Sensitive: Authentication tokens and keys
   - Derived: Computed from other metadata (public IP status)

4. File Format Standards:
   - Single line values
   - UTF-8 encoding
   - Trimmed content
   - No comments or additional formatting
   - Empty files for undefined values

5. Update Mechanisms:
   - Atomic writes using temporary files
   - Proper ownership (root:root)
   - Appropriate permissions based on sensitivity
   - Validation before storage

## Drawbacks

1. Security Considerations:
   - Centralized location for sensitive data
   - Requires careful permission management
   - Potential target for unauthorized access

2. Operational Complexity:
   - Manual updates may be required
   - No built-in versioning
   - No automatic cleanup mechanism

3. Integration Challenges:
   - May conflict with existing metadata systems
   - Requires adaptation of existing tools
   - No standard API for access
