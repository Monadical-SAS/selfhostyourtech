
#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
APP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ENV_FILE="$APP_ROOT/.env"

source "$ROOT/bin/tools.sh"

# Gitea PostgreSQL Configuration
update_env_record "GITEA_POSTGRES_USER" "gitea" "$ENV_FILE"
update_env_record "GITEA_POSTGRES_DB" "gitea" "$ENV_FILE"
update_env_record "GITEA_POSTGRES_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"

# Get base domain from config
BASE_DOMAIN_VALUE=$(yq '.base_domain' "$SELFHOSTYOURTECH_ROOT/etc/config.yaml")
add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$ENV_FILE"
