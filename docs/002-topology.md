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

1. Topology Information:
   - Provider identification
   - Region identifier (as defined by provider)
   - Zone identifier (as defined by provider)

2. Metadata Requirements:
   - Machine-readable format
   - Human-readable identifiers

3. Usage Patterns:
   - Resource placement decisions
   - Capacity planning
   - Disaster recovery planning
   - Cost allocation

### Implementation

1. Directory Structure:
   ```sh
   /var/lib/instance-metadata/
   ├── topology-provider         # Cloud provider identifier (e.g., aws, azure, gcp)
   ├── topology-region           # Provider-native region identifier
   └── topology-zone             # Provider-native zone identifier
   ```

2. Usage Example:
   ```yaml
   # Reading topology data
   metadata_topology_provider: >-
     {{
       (
         lookup('env', 'METADATA_PROVIDER') or
         lookup('file', '/var/lib/instance-metadata/topology-provider', errors='ignore')
       ) | lower
     }}
   metadata_topology_region: >-
     {{
       (
         lookup('env', 'METADATA_TOPOLOGY_REGION') or
         lookup('file', '/var/lib/instance-metadata/topology-region', errors='ignore')
       ) | lower
     }}
    ```


3. Cloud Provider Alignment, use native provider naming directly:
   - AWS: regions like `us-east-1`, zones like `us-east-1a`
   - Azure: regions like `eastus`, zones like `1`, `2`, `3`
   - GCP: regions like `us-central1`, zones like `us-central1-a`

4. Kubernetes Alignment, naming convention aligns with Kubernetes topology labels:
   - Region maps to `topology.kubernetes.io/region`
   - Zone maps to `topology.kubernetes.io/zone`


## Drawbacks
1. Increased complexity in infrastructure planning
2. Additional factors to consider in system design

## References

1. [ISO 3166-1 alpha-2 country codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
2. [Kubernetes Topology Labels](https://kubernetes.io/docs/reference/labels-annotations-taints/#topologykubernetesioregion)
