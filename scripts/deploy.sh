#!/usr/bin/env bash

set -euo pipefail

VERSION_TAG="${1:-}"
SOURCE_JAR="${2:-}"

APP_DIR="${APP_DIR:-/opt/calculator-cicd}"

RELEASES_DIR="${APP_DIR}/releases"
LOGS_DIR="${APP_DIR}/logs"
RUN_DIR="${APP_DIR}/run"

ACTIVE_INSTANCE_FILE="${RUN_DIR}/active-instance"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --------------------------------------------------
# Validate arguments
# --------------------------------------------------

if [ -z "${VERSION_TAG}" ] || [ -z "${SOURCE_JAR}" ]; then

    echo "Usage:"
    echo "  $0 <version> <jar-path>"
    echo
    echo "Example:"
    echo "  $0 v1.0.1 /tmp/calculator-cicd-1.0.1.jar"

    exit 1
fi

if [ ! -f "${SOURCE_JAR}" ]; then

    echo "Artifact not found:"
    echo "${SOURCE_JAR}"

    exit 1
fi

APP_VERSION="${VERSION_TAG#v}"

echo "========================================"
echo "          BLUE-GREEN DEPLOYMENT"
echo "========================================"
echo "Version:  ${VERSION_TAG}"
echo "Artifact: ${SOURCE_JAR}"
echo "App dir:  ${APP_DIR}"
echo "========================================"

# --------------------------------------------------
# Prepare directories
# --------------------------------------------------

mkdir -p "${RELEASES_DIR}"
mkdir -p "${LOGS_DIR}"
mkdir -p "${RUN_DIR}"

# --------------------------------------------------
# Detect active instance
# --------------------------------------------------

if [ -f "${ACTIVE_INSTANCE_FILE}" ]; then

    ACTIVE_INSTANCE=$(
        tr '[:lower:]' '[:upper:]' \
        < "${ACTIVE_INSTANCE_FILE}"
    )

else

    ACTIVE_INSTANCE="NONE"

fi

case "${ACTIVE_INSTANCE}" in

    BLUE)
        TARGET_INSTANCE="GREEN"
        TARGET_PORT=8081
        PREVIOUS_INSTANCE="BLUE"
        ;;

    GREEN)
        TARGET_INSTANCE="BLUE"
        TARGET_PORT=8080
        PREVIOUS_INSTANCE="GREEN"
        ;;

    NONE)
        TARGET_INSTANCE="BLUE"
        TARGET_PORT=8080
        PREVIOUS_INSTANCE=""
        ;;

    *)
        echo "Invalid active instance value:"
        echo "${ACTIVE_INSTANCE}"

        exit 1
        ;;
esac

echo
echo "Active instance:   ${ACTIVE_INSTANCE}"
echo "Deployment target: ${TARGET_INSTANCE}"
echo "Target port:       ${TARGET_PORT}"
echo

# --------------------------------------------------
# Store release artifact
# --------------------------------------------------

RELEASE_DIR="${RELEASES_DIR}/${VERSION_TAG}"

mkdir -p "${RELEASE_DIR}"

JAR_NAME="$(basename "${SOURCE_JAR}")"

DEPLOY_JAR="${RELEASE_DIR}/${JAR_NAME}"

echo "Storing release artifact..."

cp "${SOURCE_JAR}" "${DEPLOY_JAR}"

echo "Artifact stored at:"
echo "${DEPLOY_JAR}"

# --------------------------------------------------
# Stop previous process in target slot
# --------------------------------------------------

TARGET_LOWER=$(
    echo "${TARGET_INSTANCE}" |
    tr '[:upper:]' '[:lower:]'
)

PID_FILE="${RUN_DIR}/${TARGET_LOWER}.pid"

if [ -f "${PID_FILE}" ]; then

    OLD_PID=$(cat "${PID_FILE}")

    if kill -0 "${OLD_PID}" 2>/dev/null; then

        echo
        echo "Stopping previous ${TARGET_INSTANCE} process..."
        echo "PID: ${OLD_PID}"

        kill "${OLD_PID}"

        for i in {1..10}; do

            if ! kill -0 "${OLD_PID}" 2>/dev/null; then
                break
            fi

            sleep 1
        done

        if kill -0 "${OLD_PID}" 2>/dev/null; then

            echo "Process did not stop gracefully."
            echo "Forcing termination..."

            kill -9 "${OLD_PID}" || true
        fi
    fi

    rm -f "${PID_FILE}"
fi

# --------------------------------------------------
# Start target instance
# --------------------------------------------------

LOG_FILE="${LOGS_DIR}/${TARGET_LOWER}-${VERSION_TAG}.log"

echo
echo "Starting ${TARGET_INSTANCE}..."
echo "Version: ${APP_VERSION}"
echo "Port:    ${TARGET_PORT}"
echo "Log:     ${LOG_FILE}"

APP_INSTANCE="${TARGET_INSTANCE}" \
APP_VERSION="${APP_VERSION}" \
nohup java -jar "${DEPLOY_JAR}" \
    --server.port="${TARGET_PORT}" \
    > "${LOG_FILE}" \
    2>&1 &

NEW_PID=$!

echo "${NEW_PID}" > "${PID_FILE}"

echo "PID: ${NEW_PID}"

# --------------------------------------------------
# Health Check
# --------------------------------------------------

echo
echo "Running health check..."

if ! bash "${SCRIPT_DIR}/health-check.sh" \
    localhost \
    "${TARGET_PORT}" \
    10 \
    3; then

    echo
    echo "Deployment failed during health check."
    echo "Stopping ${TARGET_INSTANCE}..."

    kill "${NEW_PID}" 2>/dev/null || true
    rm -f "${PID_FILE}"

    echo
    echo "Previous instance remains active:"
    echo "${ACTIVE_INSTANCE}"

    exit 1
fi

# --------------------------------------------------
# E2E Validation
# --------------------------------------------------

echo
echo "Running E2E tests..."

if ! bash "${SCRIPT_DIR}/e2e-test.sh" \
    localhost \
    "${TARGET_PORT}"; then

    echo
    echo "Deployment failed during E2E validation."
    echo "Stopping ${TARGET_INSTANCE}..."

    kill "${NEW_PID}" 2>/dev/null || true
    rm -f "${PID_FILE}"

    echo
    echo "Previous instance remains active:"
    echo "${ACTIVE_INSTANCE}"

    exit 1
fi

# --------------------------------------------------
# Switch traffic
# --------------------------------------------------

echo
echo "Application validation successful."
echo "Switching traffic to ${TARGET_INSTANCE}..."

if ! bash "${SCRIPT_DIR}/switch-traffic.sh" \
    "${TARGET_INSTANCE}"; then

    echo
    echo "Traffic switch failed."

    kill "${NEW_PID}" 2>/dev/null || true
    rm -f "${PID_FILE}"

    exit 1
fi

# --------------------------------------------------
# Verify through Nginx
# --------------------------------------------------

echo
echo "Verifying application through Nginx..."

if ! bash "${SCRIPT_DIR}/e2e-test.sh" \
    localhost \
    80; then

    echo
    echo "Final verification failed."

    if [ -n "${PREVIOUS_INSTANCE}" ]; then

        echo
        echo "Starting rollback..."

        bash "${SCRIPT_DIR}/rollback.sh" \
            "${PREVIOUS_INSTANCE}"

    else

        echo
        echo "No previous instance exists for rollback."

    fi

    kill "${NEW_PID}" 2>/dev/null || true
    rm -f "${PID_FILE}"

    exit 1
fi

# --------------------------------------------------
# Mark target as active
# --------------------------------------------------

echo "${TARGET_INSTANCE}" \
    > "${ACTIVE_INSTANCE_FILE}"

echo
echo "========================================"
echo "       DEPLOYMENT SUCCESSFUL"
echo "========================================"
echo "Version:         ${VERSION_TAG}"
echo "Active instance: ${TARGET_INSTANCE}"
echo "Port:            ${TARGET_PORT}"
echo "PID:             ${NEW_PID}"
echo "Artifact:        ${DEPLOY_JAR}"
echo "Log:             ${LOG_FILE}"
echo "========================================"

exit 0