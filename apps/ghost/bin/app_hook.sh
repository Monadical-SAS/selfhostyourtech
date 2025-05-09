#!/bin/bash
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../../.." && pwd )"
APP_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

ENV_FILE="$APP_ROOT/.env"

source "$ROOT/bin/tools.sh"

update_env_record "MYSQL_DATABASE" "ghost" "$ENV_FILE"
update_env_record "MYSQL_USER" "ghost" "$ENV_FILE"
update_env_record "MYSQL_ROOT_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"
update_env_record "MYSQL_PASSWORD" "$(openssl rand -hex 32)" "$ENV_FILE"
