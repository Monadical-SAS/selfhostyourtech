#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
APP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ENV_FILE="$APP_ROOT/.env"

source "$ROOT/bin/tools.sh"

# LibreChat Configuration
update_env_record "LIBRECHAT_PORT" "3080" "$ENV_FILE"
update_env_record "UID" "1000" "$ENV_FILE"
update_env_record "GID" "1000" "$ENV_FILE"

# Authentication Configuration - Enable registration and login
update_env_record "ALLOW_EMAIL_LOGIN" "true" "$ENV_FILE"
update_env_record "ALLOW_REGISTRATION" "true" "$ENV_FILE"
update_env_record "ALLOW_SOCIAL_LOGIN" "false" "$ENV_FILE"
update_env_record "ALLOW_SOCIAL_REGISTRATION" "false" "$ENV_FILE"

# Generate JWT secrets for LibreChat
update_env_record "JWT_SECRET" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"
update_env_record "JWT_REFRESH_SECRET" "$(openssl rand -base64 64 | tr -d '\n')" "$ENV_FILE"
update_env_record "CREDS_KEY" "$(openssl rand -base64 32 | tr -d '\n')" "$ENV_FILE"
update_env_record "CREDS_IV" "$(openssl rand -base64 16 | tr -d '\n')" "$ENV_FILE"

# Session Configuration
update_env_record "SESSION_EXPIRY" "$((1000 * 60 * 15))" "$ENV_FILE"  # 15 minutes
update_env_record "REFRESH_TOKEN_EXPIRY" "$((1000 * 60 * 60 * 24 * 7))" "$ENV_FILE"  # 7 days

# Meilisearch Configuration
update_env_record "MEILI_MASTER_KEY" "$(openssl rand -base64 32 | tr -d '\n')" "$ENV_FILE"

# RAG Configuration (Optional - uncomment if you want to use RAG with OpenAI)
# update_env_record "RAG_PORT" "8000" "$ENV_FILE"
# update_env_record "RAG_ENABLED" "true" "$ENV_FILE"
# update_env_record "OPENAI_API_KEY" "your_openai_api_key_here" "$ENV_FILE"

# Get base domain from config
BASE_DOMAIN_VALUE=$(yq '.base_domain' "$SELFHOSTYOURTECH_ROOT/etc/config.yaml")
add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$ENV_FILE"

# Create necessary directories
mkdir -p "$APP_ROOT/librechat/images"
mkdir -p "$APP_ROOT/librechat/uploads"
mkdir -p "$APP_ROOT/librechat/logs"
mkdir -p "$APP_ROOT/librechat/vector_db"

# Set proper ownership for the directories
sudo chown -R 1000:1000 "$APP_ROOT/librechat/"
