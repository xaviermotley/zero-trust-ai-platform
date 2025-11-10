# Zero‑Trust AI Platform — Attested Build‑to‑Prod + Confidential Inference + Detections‑as‑Code  

**Elevator pitch:** I built an end‑to‑end security platform that cryptographically attests software from source to runtime, enforces zero‑trust workload identity, runs LLM inference only inside attested TEEs with conditional key release, and ships detections‑as‑code with a unified security data lake. It’s reproducible locally and in cloud, measured with SLOs and CI gates.  

[![Supply Chain Security](https://img.shields.io/badge/Supply%20Chain-SLSA%20%2B%20cosign-blue)]()  
[![Zero Trust Identity](https://img.shields.io/badge/Identity-SPIFFE%2FSPiRE-green)]()  
[![Confidential AI](https://img.shields.io/badge/Confidential%20AI-TEE%20Attestation-orange)]()  
[![Detections-as-Code](https://img.shields.io/badge/Detections--as--Code-purple)]()  
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)  

## Overview  
This project demonstrates how to build a production‑grade, zero‑trust AI platform by combining **software supply‑chain security**, **workload identity**, **confidential inference**, **unified telemetry**, and **AI safety evaluations**. The goal is to prove that you can cryptographically attest your code from build to deployment, enforce workload identity and authorization, decrypt model weights only inside trusted execution environments (TEEs), normalise all telemetry to OCSF, write detections as code, and measure everything with SLOs and CI gates.  

## ⚡ Quickstart  

```bash
# 1️⃣ Clone the repository
git clone https://github.com/xaviermotley/zero-trust-ai-platform.git
cd zero-trust-ai-platform

# 2️⃣ Review the infra and supply chain modules
# (e.g. Terraform/Helm for cluster, SPIRE, Kyverno, cosign)
ls infra/ supply-chain/

# 3️⃣ Explore the services and confidential inference
ls services/ confidential/

# 4️⃣ Run the sample detections and simulations
ls detections/ simulations/

# 5️⃣ Inspect AI safety harness
ls ai-safety/
```

## 🏗 Architecture  
The platform follows a secure pipeline: **Build → Sign → Attest → Admit → Confidentially Run → Detect → Respond**. The architecture diagram in `docs/architecture.md` illustrates this flow, showing how source code goes through CI to produce signed artifacts with SLSA provenance, which are then admitted into the cluster only if signatures and attestations are valid. Workloads obtain SPIFFE identities via SPIRE, request decryption keys from KMS/Key Vault only when running in an attested TEE, emit telemetry to a unified security data lake, and enforce AI safety and guardrails with continuous evaluations.  

## 📂 Repository Structure  

| Path | Purpose |
|-----|---------|
| `/infra/` | Terraform/Helm to deploy the cluster, SPIRE, policies, and TEE provider modules. |
| `/supply-chain/` | Build configs for SBOM generation, SLSA provenance, cosign signing/verification, and Kyverno policies. |
| `/services/model-gateway/` | A SPIFFE‑aware gateway service that calls the inference endpoint. |
| `/services/inference/` | The inference service or stub running inside a TEE with sealed weights. |
| `/services/policy-svc/` | Example authorization service using Cedar or OPA/Gatekeeper. |
| `/confidential/` | Scripts and configs for confidential inference (e.g., Nitro Enclaves, Secure Key Release, Confidential Space). |
| `/identity/` | SPIRE server/agent manifests and workload registration entries. |
| `/detections/` | Sigma rules and converters for detections‑as‑code. |
| `/simulations/` | Stratus Red Team and Atomic Red Team runners for validating detections. |
| `/telemetry/` | OpenTelemetry collector configs and OCSF mappings for unified telemetry. |
| `/ai-safety/` | Harnesses for AI safety evaluations using NeMo Guardrails, PyRIT, or garak. |
| `/docs/` | Architecture diagrams, threat models, runbooks, SLO definitions, and governance mappings. |
| `.github/workflows/` | CI workflows for build→sign pipelines, policy tests, evals, Scorecard, and CodeQL. |

## 📈 Key Metrics (SLOs)  

- **Attested Deployments** – percentage of deployments admitted only after verifying cosign signatures and in‑toto attestations.  
- **Attestation Latency** – mean time from build to attested deployment in production.  
- **Guardrail Catch Rate** – success rate of AI safety harness catching unsafe responses (e.g., prompt injection, data exfiltration).  
- **Policy Enforcement Rate** – ratio of admission requests rejected by Kyverno/OPA due to missing attestations or wrong identities.  
- **Detection Coverage** – proportion of validated TTPs covered by Sigma rules (via Stratus and Atomic tests).  

## 🛠 Implementation Steps  

1. **Supply‑Chain Hardening**  
   - Configure the CI to generate SBOMs and SLSA provenance.  
   - Sign container images with cosign using keyless mode.  
   - Write Kyverno `verifyImages` policies that enforce cosign signature and in‑toto attestations before deployment.  

2. **Identity‑First Runtime**  
   - Deploy SPIRE to issue SPIFFE IDs to all workloads.  
   - Enforce mTLS between services and implement authorization using Cedar policies or OPA/Gatekeeper.  

3. **Confidential Inference**  
   - Choose a cloud provider and set up a TEE (e.g., AWS Nitro Enclaves, Azure Secure Key Release, or GCP Confidential Space).  
   - Store encrypted model weights/secrets and configure KMS/Key Vault to release them only after verifying attestation claims.  
   - Demonstrate the attestation→key release flow in the `/confidential/` module.  

4. **Telemetry & Detections‑as‑Code**  
   - Instrument services with OpenTelemetry and route logs/metrics/traces to a security data lake (OCSF via Security Lake if on AWS).  
   - Author Sigma rules to detect specific attack techniques and validate them using Stratus Red Team (cloud TTPs) and Atomic Red Team (host/container).  

5. **AI Safety & Evaluations**  
   - Integrate a test harness (NeMo Guardrails, PyRIT, or garak) against your inference endpoint.  
   - Export evaluation results to JSON and fail the CI if the guardrail catch rate drops below your SLO.  
   - Map the evaluated controls to NIST AI RMF and MITRE ATLAS in a governance table within `/docs/`.  

6. **Runtime Protection (Bonus)**  
   - Deploy runtime security tools such as Cilium Tetragon or Falco.  
   - Create policies to detect and alert on suspicious behavior (e.g., execution from `/tmp` or namespace escapes).  

## 🚀 Progressive Add‑Ons  

- **Compliance Copilot** – Integrate an AI assistant (e.g., via Vanta MCP or custom chatbot) to answer questions like “what controls are failing and why?” from your telemetry and governance data.  
- **Evidence Lineage** – Include the original SBOM, provenance, and OCSF record IDs in your evidence artifacts to maintain chain‑of‑custody.  
- **Org‑Scale Backfills** – Use Step Functions distributed maps or equivalent to backfill attestations and evidence across multiple accounts and regions.  

## ⚠ Notes & Gotchas  

- **TEEs Availability** – If you don’t have access to Nitro Enclaves or other cloud TEEs, you can implement the pattern locally with a Confidential Containers (CoCo) Key Broker Service. Document how to swap this for Nitro, SKR, or Confidential Space when available.  
- **Authentication & Rate Limits** – Manage secrets (keys, OAuth tokens) securely via AWS Secrets Manager or equivalent. Respect API rate limits when integrating with external services.  
- **Policy Choices** – Decide between Kyverno vs. OPA/Gatekeeper, and Cedar vs. Rego, based on ecosystem compatibility and complexity.  
- **Security of the Repo** – Enable OpenSSF Scorecard and GitHub CodeQL workflows to keep your repository secure.  

## 📚 References  

- [SLSA Specification & cosign Quickstart](https://slsa.dev)  
- [SPIFFE/SPIRE Workload Identity](https://spiffe.io)  
- [AWS Nitro Enclaves & KMS Attestation](https://aws.amazon.com/ec2/nitro/)  
- [Azure Secure Key Release](https://learn.microsoft.com/azure/key-vault/general/key-release)  
- [GCP Confidential Space](https://cloud.google.com/confidential-computing)  
- [Open Cybersecurity Schema Framework (OCSF)](https://schema.ocsf.io)  
- [Sigma Rules & Stratus/Atomic Red Team](https://github.com/SigmaHQ/sigma)  
- [NeMo Guardrails, PyRIT, garak](https://github.com/NVIDIA/NeMo-Guardrails)  
- [NIST AI Risk Management Framework & MITRE ATLAS](https://www.nist.gov/itl/ai-risk-management-framework)  
- [OpenSSF Scorecard & GitHub CodeQL](https://securityscorecards.dev)  

## 📄 License  

MIT License © 2025 Xavier Motley
