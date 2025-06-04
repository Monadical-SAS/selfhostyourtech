#!/bin/bash

create_traefik_public_network() {
    echo "Creating traefik public network..."
    
    # Check if network already exists
    if docker network ls | grep -q "traefik-public"; then
        echo "Network traefik-public already exists."
        return 0
    fi
    
    # Create the network with specific options
    docker network create --attachable traefik-public
        
    echo "Network traefik-public created successfully."
}

tail_logs() {
    local app="$1"
    local APP_DIR="$SELFHOSTYOURTECH_ROOT/apps/$app"
    cd "$APP_DIR" || exit 1
    docker compose logs -f --no-color 2>&1 | sed "s/^/[$app] /"
}

extract_domain() {
    echo "$1" | sed -E 's/.*\.([^.]+\.[^.]+)$/\1/'
}

add_key_in_env() {
    local KEY=$1
    local VALUE=$2
    local ENV_FILE=$3
    if grep -q "^${KEY}=" "$ENV_FILE"; then
        # Key exists, update it
        sed -i "s|^${KEY}=.*|${KEY}=${VALUE}|" "$ENV_FILE"
        echo "Updated $KEY in $ENV_FILE"
    else
        # Key doesn't exist, append it
        echo "${KEY}=${VALUE}" >> "$ENV_FILE"
        echo "Added $KEY to $ENV_FILE"
    fi
}

update_env_record() {
    local key="$1"
    local value="$2"
    local env_file="$3"
    
    # Check if all required parameters are provided
    if [[ -z "$key" || -z "$value" || -z "$env_file" ]]; then
        echo "Error: Missing required parameters. Usage: update_env_record KEY VALUE ENV_FILE_PATH"
        return 1
    fi
    
    # Check if the .env file exists
    if [[ ! -f "$env_file" ]]; then
        echo "Error: .env file does not exist at path: $env_file"
        touch "$env_file"
    fi
    
    # Check if the key exists with a non-empty value
    if grep -q "^${key}=.\+" "$env_file"; then
        echo "Key '$key' already exists with a non-empty value in $env_file. No update performed."
    # Check if the key exists but is empty
    elif grep -q "^${key}=$" "$env_file"; then
        sed -i "s|^${key}=|${key}=${value}|" "$env_file"
        echo "Updated empty key '$key' with value '$value' in $env_file"
    else
        # Add new key
        echo "${key}=${value}" >> "$env_file"
        echo "Added new key '$key' with value '$value' to $env_file"
    fi
    
    return 0
}

run_app_hook() {
    local directory_path="$1"
    
    # Check if directory path is provided
    if [[ -z "$directory_path" ]]; then
        echo "Error: Directory path is required. Usage: run_app_hook DIRECTORY_PATH"
        return 1
    fi
    
    # Check if the directory exists
    if [[ ! -d "$directory_path" ]]; then
        echo "Error: Directory does not exist at path: $directory_path"
        return 1
    fi
    
    # Path to the script
    local script_path="${directory_path}/bin/app_hook.sh"
    
    # Check if the script exists
    if [[ -f "$script_path" ]]; then
        # Check if the script is executable
        if [[ -x "$script_path" ]]; then
            echo "Running app_hook.sh script in $directory_path..."
            "$script_path"
            return $?
        fi
    else
        echo "Script app_hook.sh does not exist in directory: $directory_path"
        touch "${directory_path}/.env"
    fi
}

generate_supervisor_config() {
    APPS_LIST="$1"
    APPS_DIR="$2"
    CONF_DIR="$3"
    SELFHOSTYOURTECH_ROOT="$4"

    mkdir -p "$CONF_DIR"
    find /opt/selfhostyourtech/etc/supervisor/conf.d/ -type f -delete
    for app in $APPS_LIST; do
        app_dir="$APPS_DIR/$app"
        if [ -f "$app_dir/docker-compose.yml" ]; then
            app_name=$(basename "$app_dir")
            cat > "$CONF_DIR/$app_name.conf" << EOF
[program:$app_name]
command=docker compose up
directory=$SELFHOSTYOURTECH_ROOT/apps/$app_name
autostart=true
autorestart=true
stderr_logfile=/var/log/supervisor/$app_name.err.log
stdout_logfile=/var/log/supervisor/$app_name.out.log
stopsignal=QUIT
stopwaitsecs=30
EOF
            echo "Created supervisor config for $app_name"
        fi
    done
}