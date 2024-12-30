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
- Data locality

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
   ```sh
   /var/lib/instance-metadata/
   ├── topology-region           # Geographic region identifier
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

4. Kubernetes Alignment:
   - Naming convention aligns with Kubernetes topology labels:
     * Region maps to `topology.kubernetes.io/region`
     * Zone maps to `topology.kubernetes.io/zone`
   - Consistent topology awareness across different platforms

## Cloud Provider Compatibility

Each major cloud provider has established their own topology naming conventions. Our proposal needs to accommodate mapping between these formats:

### AWS Regions and Availability Zones
- Region format: `^[a-z]{2}-[a-z]+-[0-9]+$` (e.g., `us-east-1`, `eu-west-2`)
- AZ format: `^[a-z]{2}-[a-z]+-[0-9][a-z]$` (e.g., `us-east-1a`, `eu-west-2b`)

Example mapping:
- `us-east-1` → `us-1`
- `eu-west-2` → `eu-2`
- `ap-southeast-1` → `sg-1`

### Azure Regions
- Region format: `^[a-z]+$` or `^[a-z]+[0-9]+$` (e.g., `eastus`, `westeurope`, `eastus2`)
- Zone format: Numeric (1,2,3) within a region

Example mapping:
- `eastus` → `us-1`
- `westeurope` → `eu-1`
- `eastus2` → `us-2`

### Google Cloud Platform (GCP)
- Region format: `^[a-z]+-[a-z]+[0-9]+$` (e.g., `us-central1`, `europe-west4`)
- Zone format: `^[a-z]+-[a-z]+[0-9]+-[a-z]$` (e.g., `us-central1-a`, `europe-west4-b`)

Example mapping:
- `us-central1` → `us-1`
- `europe-west4` → `eu-4`
- `asia-east1` → `hk-1`

### Implementation Considerations
1. Implementations should maintain mapping tables between cloud provider-specific formats and our standardized format
2. Region mapping should consider geographical accuracy (e.g., `ap-southeast-1` maps to `sg-1` as it's located in Singapore)
3. Tools should support both native cloud provider formats and our standardized format
4. Documentation should clearly specify mapping rules for each supported cloud provider

## Drawbacks
1. Increased complexity in infrastructure planning
2. Additional factors to consider in system design

## References

1. [ISO 3166-1 alpha-2 country codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
2. [Kubernetes Topology Labels](https://kubernetes.io/docs/reference/labels-annotations-taints/#topologykubernetesioregion)
