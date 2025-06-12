#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
APP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ENV_FILE="$APP_ROOT/.env"

source "$ROOT/bin/tools.sh"

update_env_record "AUTHENTIK_SECRET_KEY" "$(openssl rand -base64 60 | tr -d '\n')" "$ENV_FILE"
update_env_record "PG_USER" "traefik" "$ENV_FILE"
update_env_record "PG_DB" "traefik" "$ENV_FILE"
update_env_record "PG_PASS" "$(openssl rand -hex 16)" "$ENV_FILE"
update_env_record "AUTHENTIK_LISTEN__HTTP" "0.0.0.0:9000" "$ENV_FILE"
update_env_record "AUTHENTIK_LISTEN__HTTPS" "0.0.0.0:9443" "$ENV_FILE"

BASE_DOMAIN_VALUE=$(yq '.base_domain' "$SELFHOSTYOURTECH_ROOT/etc/config.yaml")
add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$ENV_FILE"
