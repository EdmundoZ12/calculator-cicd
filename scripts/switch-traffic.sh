#!/usr/bin/env bash

set -euo pipefail

TARGET_INSTANCE="${1:-}"

NGINX_CONFIG="${NGINX_CONFIG:-/etc/nginx/conf.d/calculator-cicd.conf}"

if [ -z "${TARGET_INSTANCE}" ]; then
    echo "Usage: $0 BLUE|GREEN"
    exit 1
fi

TARGET_INSTANCE=$(
    echo "${TARGET_INSTANCE}" |
    tr '[:lower:]' '[:upper:]'
)

case "${TARGET_INSTANCE}" in
    BLUE)
        TARGET_PORT=8080
        ;;

    GREEN)
        TARGET_PORT=8081
        ;;

    *)
        echo "Invalid instance: ${TARGET_INSTANCE}"
        echo "Allowed values: BLUE or GREEN"
        exit 1
        ;;
esac

echo "========================================"
echo "          SWITCH TRAFFIC"
echo "========================================"
echo "Target instance: ${TARGET_INSTANCE}"
echo "Target port:     ${TARGET_PORT}"
echo "Nginx config:    ${NGINX_CONFIG}"
echo "========================================"

TEMP_CONFIG=$(mktemp)
BACKUP_CONFIG=$(mktemp)

cleanup() {
    rm -f "${TEMP_CONFIG}"
    rm -f "${BACKUP_CONFIG}"
}

trap cleanup EXIT

cat > "${TEMP_CONFIG}" <<EOF
upstream calculator_backend {
    server 127.0.0.1:${TARGET_PORT};
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://calculator_backend;

        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

HAS_PREVIOUS_CONFIG=false

if sudo test -f "${NGINX_CONFIG}"; then

    sudo cat "${NGINX_CONFIG}" > "${BACKUP_CONFIG}"

    HAS_PREVIOUS_CONFIG=true
fi

echo "Applying candidate Nginx configuration..."

sudo mkdir -p "$(dirname "${NGINX_CONFIG}")"

sudo cp "${TEMP_CONFIG}" "${NGINX_CONFIG}"

echo "Validating Nginx configuration..."

if ! sudo nginx -t; then

    echo
    echo "New Nginx configuration is invalid."
    echo "Restoring previous configuration..."

    if [ "${HAS_PREVIOUS_CONFIG}" = true ]; then
        sudo cp "${BACKUP_CONFIG}" "${NGINX_CONFIG}"
    else
        sudo rm -f "${NGINX_CONFIG}"
    fi

    sudo nginx -t || true

    echo "Traffic switch aborted."

    exit 1
fi

echo "Reloading Nginx..."

if ! sudo systemctl reload nginx; then

    echo
    echo "Nginx reload failed."
    echo "Restoring previous configuration..."

    if [ "${HAS_PREVIOUS_CONFIG}" = true ]; then

        sudo cp "${BACKUP_CONFIG}" "${NGINX_CONFIG}"

        sudo nginx -t
        sudo systemctl reload nginx

    else

        sudo rm -f "${NGINX_CONFIG}"

    fi

    exit 1
fi

echo
echo "Traffic switched successfully."
echo "Active instance: ${TARGET_INSTANCE}"
echo "Active port:     ${TARGET_PORT}"
echo

exit 0