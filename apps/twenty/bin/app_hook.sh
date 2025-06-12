#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
APP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ENV_FILE="$APP_ROOT/.env"

source "$ROOT/bin/tools.sh"

update_env_record "PG_DATABASE_USER" "postgres" "$ENV_FILE"
update_env_record "PG_DATABASE_PASSWORD" "$(openssl rand -hex 16)" "$ENV_FILE"
update_env_record "APP_SECRET" "$(openssl rand -hex 16)" "$ENV_FILE"
update_env_record "MINIO_ROOT_USER" "minioadmin" "$ENV_FILE"
update_env_record "MINIO_ROOT_PASSWORD" "$(openssl rand -hex 16)" "$ENV_FILE"
update_env_record "STORAGE_TYPE" "s3" "$ENV_FILE"
update_env_record "STORAGE_S3_NAME" "twenty-bucket" "$ENV_FILE"
update_env_record "STORAGE_S3_ENDPOINT" "http://minio:9000" "$ENV_FILE"
update_env_record "STORAGE_S3_REGION" "us-east-1" "$ENV_FILE"

BASE_DOMAIN_VALUE=$(yq '.base_domain' "$SELFHOSTYOURTECH_ROOT/etc/config.yaml")
add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$ENV_FILE"
