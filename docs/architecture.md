# Azure Landing Zone architecture

## Design principles

- Secure by default
- Least privilege access
- Modular and reusable
- Production ready
- Central India as the default region

## Subscription model

- Bootstrap: Terraform backend only
- Hub: shared network services
- Shared Services: monitoring, security, and platform services
- Dev: non-production workloads
- Prod: production workloads

## Deployment order

1. Bootstrap
2. Hub
3. Shared Services
4. Dev
5. Prod

## Notes

This repository is intentionally scaffolded as a starting point.
Expand the modules with actual connectivity, identity, policy, and workload resources before production deployment.
