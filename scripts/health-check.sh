#!/usr/bin/env bash

set -euo pipefail

HOST="${1:-localhost}"
PORT="${2:-8080}"
MAX_ATTEMPTS="${3:-10}"
WAIT_SECONDS="${4:-3}"

HEALTH_URL="http://${HOST}:${PORT}/actuator/health"

echo "========================================"
echo "        APPLICATION HEALTH CHECK"
echo "========================================"
echo "Host: ${HOST}"
echo "Port: ${PORT}"
echo "URL:  ${HEALTH_URL}"
echo "========================================"

for ((ATTEMPT=1; ATTEMPT<=MAX_ATTEMPTS; ATTEMPT++)); do

    echo "Attempt ${ATTEMPT}/${MAX_ATTEMPTS}..."

    RESPONSE=$(curl -fsS "${HEALTH_URL}" 2>/dev/null || true)

    if echo "${RESPONSE}" | grep -q '"status":"UP"'; then
        echo
        echo "Health check successful."
        echo "Application is UP on port ${PORT}."
        echo
        exit 0
    fi

    if [ "${ATTEMPT}" -lt "${MAX_ATTEMPTS}" ]; then
        echo "Application is not ready. Retrying in ${WAIT_SECONDS} seconds..."
        sleep "${WAIT_SECONDS}"
    fi
done

echo
echo "Health check failed."
echo "Application is not healthy on port ${PORT}."
echo

exit 1