#!/usr/bin/env bash
set -euo pipefail
IMAGE="$1"
OUTPUT_DIR="${2:-./sbom}"
mkdir -p "$OUTPUT_DIR"
syft "$IMAGE" -o cyclonedx-json > "$OUTPUT_DIR/sbom.json"
echo "SBOM generated at $OUTPUT_DIR/sbom.json"
