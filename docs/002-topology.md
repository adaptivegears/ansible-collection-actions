# EP-002: Topology Metadata

## Summary
This enhancement proposal explores the fundamental need for topology awareness in modern infrastructure, addressing why systems need to understand their physical and logical location within the broader infrastructure landscape.

## Motivation
Infrastructure systems require awareness of their location and relationships within the broader ecosystem to enable:
- Resource allocation and failover
- Load balancing and traffic routing
- Latency optimization
- Cost-effective resource distribution
- Disaster recovery capabilities

The lack of topology awareness leads to:
- Increased operational costs
- Reduced system resilience
- Compliance violations
- Poor user experience

### Goals
- Define why systems need topology awareness
- Enable location-aware operations

### Non-Goals
- Defining specific topology implementations
- Detailing technical storage solutions
- Creating topology management tools

## Proposal
Establish a standardized approach for topology metadata that includes:

1. Topology Hierarchy:
   - Two-level hierarchy (region/zone) for resource organization
   - Clear naming conventions for identifiers

2. Metadata Requirements:
   - Machine-readable format
   - Human-readable identifiers

3. Usage Patterns:
   - Resource placement decisions
   - Capacity planning
   - Disaster recovery planning
   - Cost allocation

### Implementation

1. Naming Conventions:
   - Region identifier format: `^[a-z]{2}-[0-9]+$`
     * Two lowercase letters representing ISO 3166-1 alpha-2 country code (e.g., `us`, `de`, `sg`)
     * Numeric identifier (e.g., `us-1`, `de-2`)
   - Zone identifier format: `^[a-z]{2}-[0-9]+[a-z]?$`
     * Inherits region format
     * Optional lowercase letter suffix (e.g., `us-1a`, `de-2b`)

2. Directory Structure:
   ```
   /var/lib/instance-metadata/
   ├── topology-region            # Geographic region identifier
   └── topology-zone             # Availability zone identifier
   ```

3. Usage Example:
   ```yaml
   # Reading topology data
   metadata_topology_region: >-
     {{
       (
         lookup('env', 'METADATA_TOPOLOGY_REGION') or
         lookup('file', '/var/lib/instance-metadata/topology-region', errors='ignore')
       ) | lower
     }}
    ```

## Drawbacks
1. Increased complexity in infrastructure planning
2. Additional factors to consider in system design

## References

1. [ISO 3166-1 alpha-2 country codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
