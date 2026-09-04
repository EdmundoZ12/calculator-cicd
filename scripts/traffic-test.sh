#!/usr/bin/env bash

set -euo pipefail

HOST="${1:-localhost}"
PORT="${2:-8080}"
REQUESTS="${3:-10}"

INSTANCE_URL="http://${HOST}:${PORT}/api/instance"

echo "========================================"
echo "           TRAFFIC TEST"
echo "========================================"
echo "Host: ${HOST}"
echo "Port: ${PORT}"
echo "Requests: ${REQUESTS}"
echo "URL: ${INSTANCE_URL}"
echo "========================================"
echo

for ((i=1; i<=REQUESTS; i++)); do

    RESPONSE=$(curl -fsS "${INSTANCE_URL}" 2>/dev/null || true)

    if [ -z "${RESPONSE}" ]; then
        echo "[${i}/${REQUESTS}] Request failed."
        exit 1
    fi

    echo "[${i}/${REQUESTS}] ${RESPONSE}"

    sleep 0.5
done

echo
echo "Traffic test completed successfully."
echo

exit 0