#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
APP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ENV_FILE="$APP_ROOT/.env"

source "$ROOT/bin/tools.sh"

update_env_record "POSTGRES_USER" "hedgedoc" "$ENV_FILE"
update_env_record "POSTGRES_DB" "hedgedoc" "$ENV_FILE"
update_env_record "POSTGRES_PASSWORD" "$(openssl rand -hex 16)" "$ENV_FILE"
update_env_record "HD_SESSION_SECRET" "$(openssl rand -hex 32)" "$ENV_FILE"

BASE_DOMAIN_VALUE=$(cat "$ROOT/etc/basedomain.txt")
add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$ENV_FILE"
