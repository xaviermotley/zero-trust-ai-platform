# Zero Trust AI Platform — Attested Build‑to‑Prod + Confidential Inference + Detections‑as‑Code  

**Elevator pitch:** I built an end‑to‑end security platform that cryptographically attests software from source to runtime, enforces zero‑trust workload identity, runs LLM inference only inside attested TEEs with conditional key release, and ships detections‑as‑code with a unified security data lake. It’s reproducible locally and in cloud, measured with SLOs and CI gates.  

[![Supply Chain Security](https://img.shields.io/badge/Supply%20Chain-SLSA%20%2B%20cosign-blue)]()  [![Zero Trust Identity](https://img.shields.io/badge/Identity-SPIFFE%2FSPiRE-green)]()  [![Confidential AI](https://img.shields.io/badge/Confidential%20AI-TEE%20Attestation-orange)]()  [![Detections‑as‑Code](https://img.shields.io/badge/Detections--as--Code-purple)]()  [![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)  

## Overview  

This project demonstrates how to build a production‑grade, zero‑trust AI platform by combining **software supply‑chain security**, **workload identity**, **confidential inference**, **unified telemetry**, and **AI safety evaluations**. The goal is to prove that you can cryptographically attest your code from build to deployment, enforce workload identity and authorization, decrypt model weights only inside trusted execution environments (TEEs), normalise all telemetry to OCSF, write detections as code, and measure everything with SLOs and CI gates.  

## ⚡ Quickstart  

```bash
# 1⃣ Clone the repository
git clone https://github.com/xaviermotley/zero-trust-ai-platform.git
cd zero-trust-ai-platform

# 2⃣ Review the infra and supply chain modules
# (e.g. Terraform/Helm for cluster, SPIRE, Kyverno, cosign)
ls infra/ supply-chain/

# 3⃣ Explore the services and confidential inference
ls services/ confidential/

# 4⃣ Run the sample detections and simulations
ls detections/ simulations/

# 5⃣ Inspect AI safety harness
ls ai-safety/
```  

## 🏗 Architecture  

The platform follows a secure pipeline: **Build → Sign → Attest → Admit → Confidentially Run → Detect → Respond**. The architecture diagram in `docs/architecture.md` illustrates this flow, showing how source code goes through CI to produce signed artifacts with SLSA provenance, which are then admitted into the cluster only if signatures and attestations are valid. Workloads obtain SPIFFE identities via SPIRE, request decryption keys from KMS/Key Vault only when running in an attested TEE, emit telemetry to a unified security data lake, and enforce AI safety with continuous evaluations.  

## 🗂 Repository Structure  

| Folder | Purpose |
|---|---|
| `infra/` | Terraform/Helm modules for cluster, SPIRE, policies, and TEE path |
| `supply-chain/` | SBOM and provenance generation, cosign signing/verification, Kyverno policies |
| `services/model-gateway/` | SPIFFE‑aware gateway that invokes the inference service |
| `services/inference/` | In‑TEE inference service or stub with sealed weights |
| `services/policy-svc/` | Authorization example using Cedar or OPA |
| `confidential/` | Scripts and policies for confidential computing (Nitro Enclaves, SKR, Confidential Space) |
| `identity/` | SPIRE server/agent manifests and workload registrations |
| `detections/` | Sigma rules for detections‑as‑code |
| `simulations/` | Stratus Red Team and Atomic Red Team runners |
| `telemetry/` | OpenTelemetry collector configs and OCSF mappings |
| `ai-safety/` | PyRIT/garak harness and NeMo Guardrails configs |
| `docs/` | Architecture diagrams, runbooks, SLOs, and governance mapping |
| `.github/workflows/` | CI pipelines for build/sign/verify, tests, evals, Scorecard & CodeQL |

## 📈 Key Metrics (SLOs)  

| Metric | Description |
|---|---|
| **Attested deploy rate** | Percentage of deployments with valid signatures & attestations |
| **Mean time to attested deploy** | Average time from commit to attested deployment |
| **Guardrail catch‑rate** | Percentage of AI safety tests caught by guardrails |
| **Policy enforcement rate** | Percentage of admission requests rejected by verifyImages & authz policies |
| **Detection coverage** | Fraction of tested TTPs detected by Sigma rules |

## 🚀 Implementation Steps  

- **Week 1: Supply chain MVP** – Generate SBOM and SLSA provenance; sign images with cosign; enforce verifyImages with Kyverno.  
- **Week 2: Identity & authz** – Deploy SPIRE for workload identities; enforce mTLS; implement a simple Cedar/OPA authorization check.  
- **Week 3: Telemetry & detections** – Configure OpenTelemetry and Security Lake/OCSF; write a couple of Sigma rules; validate one Stratus technique.  
- **Week 4: Confidential inference** – Implement attestation‑gated key release using one cloud provider (Nitro Enclaves, SKR, or Confidential Space).  
- **Week 5: AI safety & runtime** – Wire PyRIT or garak with NeMo Guardrails; add 1‑2 runtime security policies (eBPF/Falco); finalize SLO tracking and governance mapping.  

## 🧩 Progressive Add‑Ons  

- **Compliance copilot** – Integrate with open‑source Vanta MCP server or similar to answer “what controls are failing & why?”.  
- **Evidence lineage** – Attach original OCSF record or ARN to your evidence for chain‑of‑custody.  
- **Org‑scale backfills** – Use Step Functions Distributed Map for multi‑account backfills or periodic control re‑evidence.  

## 📝 Notes & Gotchas  

- If hardware TEEs aren’t available, you can demonstrate the attestation‑gated decryption pattern locally using Confidential Containers (CoCo) Key Broker Service. Document how to swap in Nitro Enclaves, Azure SKR, or GCP Confidential Space when running in cloud.  
- Workload identity is critical; ensure all services use SPIRE‑issued SPIFFE IDs and enforce mTLS.  
- Policy sprawl can be complex: decide between Cedar and OPA based on expressiveness and ecosystem.  
- Respect key release rate limits and monitor attestation verifications for latency.  

## 📚 References  

- SLSA specification, cosign quickstart, and Kyverno verifyImages  
- SPIFFE/SPIRE workload identity  
- AWS Nitro Enclaves & KMS, Azure Secure Key Release, GCP Confidential Space  
- OCSF & Security Lake, OpenTelemetry  
- Sigma rules, Stratus Red Team, Atomic Red Team  
- NeMo Guardrails, PyRIT, garak; NIST AI RMF & MITRE ATLAS  
- OpenSSF Scorecard, GitHub CodeQL  

## 📄 License  

MIT License © 2025 Xavier Motley
