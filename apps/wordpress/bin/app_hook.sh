#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
APP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ENV_FILE="$APP_ROOT/.env"

source "$ROOT/bin/tools.sh"

# WordPress MariaDB Configuration
update_env_record "WORDPRESS_MYSQL_ROOT_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"
update_env_record "WORDPRESS_MYSQL_USER" "wordpress" "$ENV_FILE"
update_env_record "WORDPRESS_MYSQL_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"
update_env_record "WORDPRESS_MYSQL_DATABASE" "wordpress" "$ENV_FILE"

# Generate WordPress salts and keys
update_env_record "WORDPRESS_AUTH_KEY" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"
update_env_record "WORDPRESS_SECURE_AUTH_KEY" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"
update_env_record "WORDPRESS_LOGGED_IN_KEY" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"
update_env_record "WORDPRESS_NONCE_KEY" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"
update_env_record "WORDPRESS_AUTH_SALT" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"
update_env_record "WORDPRESS_SECURE_AUTH_SALT" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"
update_env_record "WORDPRESS_LOGGED_IN_SALT" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"
update_env_record "WORDPRESS_NONCE_SALT" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"

# Get base domain from config
BASE_DOMAIN_VALUE=$(yq '.base_domain' "$SELFHOSTYOURTECH_ROOT/etc/config.yaml")
add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$ENV_FILE"
