---
revision: 2
status: draft
---

# EP-002: Topology Metadata

## Summary
This enhancement proposal explores the fundamental need for topology awareness in modern infrastructure, addressing why systems need to understand their physical location within the broader infrastructure landscape.

## Motivation
Infrastructure systems require awareness of their location and relationships within the broader ecosystem to enable:
- Resource allocation and failover
- Load balancing and traffic routing
- Latency optimization
- Cost-effective resource allocation
- Disaster recovery capabilities
- Data locality

The lack of topology awareness potentially leads to:
- Reduced system resilience
- Increased operational costs
- Compliance violations
- Poor user experience

### Goals
- Define why systems need topology awareness
- Enable location-aware operations

### Non-Goals
- Creating topology management tools

## Proposal
Establish a standardized approach for topology metadata.

### Topology Information

Topology data includes:
- `provider` identifier
- `region` identifier (as defined by provider)
- `zone` identifier (as defined by provider)

Providers are cloud platforms like AWS, Azure, GCP, or DigitalOcean. Regions and zones are provider-specific identifiers that define the physical location of resources. For example, AWS regions like `us-east-1` and zones like `us-east-1a`.

Some providers don't use combination of regions and zones, like DigitalOcean, which uses a single `region` identifier. In such cases, the `region` identifier is used as the `zone` identifier, because there's no further granularity.

For on-premises deployments, the `provider` identifier can be the organization's name, while `region` and `zone` can be the data center and rack identifiers.

### Topology Metadata Requirements

Requirements for topology metadata:
- Machine-readable format
- Human-readable identifiers

Plaintext files are used to store topology metadata, with each file containing a single identifier. The files are stored in a common directory, `/var/lib/instance-metadata/`. The directory structure is as follows:
```sh
/var/lib/instance-metadata/
├── topology-provider         # Cloud provider identifier (e.g., aws, azure, gcp)
├── topology-region           # Provider-native region identifier
└── topology-zone             # Provider-native zone identifier
```

Identifiers are expected to be lowercase, alphanumeric strings with hyphens allowed. For example, `aws`, `us-east-1`, `us-east-1a`. Thus, full topology identifiers can be expressed as:
- `aws/us-east-1/us-east-1a`
- `azure/eastus/1`
- `gcp/us-central1/us-central1-a`

This information won't be sufficient for all use cases, as it doesn't provide detailed network topology or logical grouping information (VPCs, subnets, etc.). However, it's enough for basic location-aware operations. For more detailed information, additional metadata sources like cloud APIs or configuration management tools can be used.

### Topology Metadata Discovery

Topology information can be obtained through multiple methods:

1. **Metadata Services** (Recommended):
- AWS: EC2 Instance Metadata Service (IMDS) at `http://169.254.169.254`
- Azure: Instance Metadata Service (IMDS) at `http://169.254.169.254`
- GCP: Compute Engine Metadata Server at `http://metadata.google.internal`
- DigitalOcean: Metadata Service at `http://169.254.169.254`

2. **Manual Configuration**:
- Environment variables
- Configuration files
- Command-line arguments

3. **Infrastructure as Code**:
- Terraform outputs
- CloudFormation exports
- Ansible inventory variables

### Topology Use Cases

Topology information (`provider`/`region`/`zone`) informs about following aspects:

Connectivity:
- Expected latency ranges between components
- Network bandwidth characteristics
- Network isolation boundaries
- Network costs (free vs paid traffic)

Storage:
- Data accessibility boundaries
- Storage attachment restrictions
- Replication possibilities
- Data sovereignty compliance

Cost Model:
- Data transfer pricing tiers
- Replication costs
- Backup storage costs

Topology metadata can be used to provide locality-based services, such as Kubernetes pod scheduling, load balancing, or data replication using following labels:
- Region maps to `topology.kubernetes.io/region`
- Zone maps to `topology.kubernetes.io/zone`

## References
1. [ISO 3166-1 alpha-2 country codes](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2)
2. [Kubernetes Topology Labels](https://kubernetes.io/docs/reference/labels-annotations-taints/#topologykubernetesioregion)
