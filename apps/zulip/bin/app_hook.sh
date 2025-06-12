#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
APP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ENV_FILE="$APP_ROOT/.env"

source "$ROOT/bin/tools.sh"

update_env_record "POSTGRES_USER" "zulip" "$ENV_FILE"
update_env_record "POSTGRES_DB" "zulip" "$ENV_FILE"
update_env_record "POSTGRES_PASSWORD" "$(openssl rand -hex 16)" "$ENV_FILE"
update_env_record "MEMCACHED_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"
update_env_record "REDIS_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"
update_env_record "RABBITMQ_USER" "zulip" "$ENV_FILE"
update_env_record "RABBITMQ_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"
update_env_record "ZULIP_SECRET_KEY" "$(openssl rand -base64 32)" "$ENV_FILE"
update_env_record "ZULIP_SECRET_KEY" "$(openssl rand -base64 32)" "$ENV_FILE"

BASE_DOMAIN_VALUE=$(yq '.base_domain' "$SELFHOSTYOURTECH_ROOT/etc/config.yaml")
add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$ENV_FILE"

EMAIL_HOST_USER_VALUE=$(yq '.default_admin_email' "$SELFHOSTYOURTECH_ROOT/etc/config.yaml")
add_key_in_env "EMAIL_HOST_USER" "$EMAIL_HOST_USER_VALUE" "$ENV_FILE"

echo "Complete EMAIL_HOST_USER env variable please ..."
