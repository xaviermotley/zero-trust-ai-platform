#!/usr/bin/env bash
set -euo pipefail

IMAGE="$1"
PROVENANCE="${2:-./provenance.json}"
KEY="${COSIGN_KEY:-cosign.key}"

# Sign the container image
cosign sign --key "$KEY" "$IMAGE"

# Generate SLSA provenance attestation
cosign attest --key "$KEY" --type slsaprovenance --predicate "$PROVENANCE" "$IMAGE"

echo "Image signed and attested with SLSA provenance."
