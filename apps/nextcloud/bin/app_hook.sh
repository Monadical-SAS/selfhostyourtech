#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
APP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ENV_FILE="$APP_ROOT/.env"

source "$ROOT/bin/tools.sh"

update_env_record "MYSQL_DATABASE" "nextcloud" "$ENV_FILE"
update_env_record "MYSQL_USER" "nextcloud" "$ENV_FILE"
update_env_record "MYSQL_ROOT_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"
update_env_record "MYSQL_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"
update_env_record "TRUSTED_PROXIES" "172.0.0.0/8" "$ENV_FILE"

BASE_DOMAIN_VALUE=$(yq '.base_domain' "$SELFHOSTYOURTECH_ROOT/etc/config.yaml")
add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$ENV_FILE"
