#!/usr/bin/env bash

set -euo pipefail

PREVIOUS_INSTANCE="${1:-}"

APP_DIR="${APP_DIR:-/opt/calculator-cicd}"
RUN_DIR="${APP_DIR}/run"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "${PREVIOUS_INSTANCE}" ]; then
    echo "Usage: $0 BLUE|GREEN"
    exit 1
fi

PREVIOUS_INSTANCE=$(
    echo "${PREVIOUS_INSTANCE}" |
    tr '[:lower:]' '[:upper:]'
)

case "${PREVIOUS_INSTANCE}" in
    BLUE)
        PREVIOUS_PORT=8080
        ;;

    GREEN)
        PREVIOUS_PORT=8081
        ;;

    *)
        echo "Invalid instance: ${PREVIOUS_INSTANCE}"
        echo "Allowed values: BLUE or GREEN"
        exit 1
        ;;
esac

echo "========================================"
echo "              ROLLBACK"
echo "========================================"
echo "Restoring instance: ${PREVIOUS_INSTANCE}"
echo "Port: ${PREVIOUS_PORT}"
echo "========================================"

echo
echo "Checking previous instance before rollback..."

if ! bash "${SCRIPT_DIR}/health-check.sh" \
    localhost \
    "${PREVIOUS_PORT}" \
    5 \
    2; then

    echo
    echo "Rollback failed."
    echo "Previous instance is not healthy."

    exit 1
fi

echo
echo "Previous instance is healthy."

echo
echo "Restoring traffic..."

bash "${SCRIPT_DIR}/switch-traffic.sh" \
    "${PREVIOUS_INSTANCE}"

echo
echo "Verifying rollback through Nginx..."

if ! bash "${SCRIPT_DIR}/e2e-test.sh" \
    localhost \
    80; then

    echo
    echo "Rollback verification failed."

    exit 1
fi

mkdir -p "${RUN_DIR}"

echo "${PREVIOUS_INSTANCE}" \
    > "${RUN_DIR}/active-instance"

echo
echo "========================================"
echo "        ROLLBACK SUCCESSFUL"
echo "========================================"
echo "Active instance: ${PREVIOUS_INSTANCE}"
echo "Active port:     ${PREVIOUS_PORT}"
echo "========================================"

exit 0