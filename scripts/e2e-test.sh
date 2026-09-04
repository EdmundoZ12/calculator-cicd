#!/usr/bin/env bash

set -euo pipefail

HOST="${1:-localhost}"
PORT="${2:-8080}"

FIRST_NUMBER=2
SECOND_NUMBER=3
EXPECTED_RESULT=5

E2E_URL="http://${HOST}:${PORT}/api/add?a=${FIRST_NUMBER}&b=${SECOND_NUMBER}"

echo "========================================"
echo "          END-TO-END TEST"
echo "========================================"
echo "Host: ${HOST}"
echo "Port: ${PORT}"
echo "Test: ${FIRST_NUMBER} + ${SECOND_NUMBER}"
echo "Expected result: ${EXPECTED_RESULT}"
echo "URL: ${E2E_URL}"
echo "========================================"

RESPONSE=$(curl -fsS "${E2E_URL}" 2>/dev/null || true)

if [ -z "${RESPONSE}" ]; then
    echo
    echo "E2E test failed."
    echo "No response received from the application."
    echo
    exit 1
fi

echo
echo "Response:"
echo "${RESPONSE}"
echo

if echo "${RESPONSE}" |
    grep -Eq "\"result\"[[:space:]]*:[[:space:]]*${EXPECTED_RESULT}(\.0)?([,}])"; then

    echo "E2E test successful."
    echo "${FIRST_NUMBER} + ${SECOND_NUMBER} = ${EXPECTED_RESULT}"
    echo

    exit 0
fi

echo "E2E test failed."
echo "Expected result: ${EXPECTED_RESULT}"
echo

exit 1