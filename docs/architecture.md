# Architecture Overview

The zero-trust AI platform follows a secure pipeline:

1. **Build** – Source code is built into container images.
2. **Sign** – Images are signed with Cosign.
3. **Attest** – Supply chain attestations (SBOM, provenance) are generated with SLSA.
4. **Admit** – Kyverno policies enforce signature and attestation verification before deployment.
5. **Run Confidentially** – Workloads run in confidential computing environments using SPIFFE identities.
6. **Detect & Respond** – Telemetry collected via OpenTelemetry is converted to OCSF and monitored for anomalies.

This ensures end-to-end supply chain security and runtime integrity.
