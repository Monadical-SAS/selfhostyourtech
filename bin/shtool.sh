#!/bin/bash

set -e

SCRIPTS_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SELFHOSTYOURTECH_ROOT="$( dirname "$SCRIPTS_ROOT")"
APPS_ENABLED_FILE="$SELFHOSTYOURTECH_ROOT"/etc/apps-enabled.yaml

tail_logs() {
    local app="$1"
    local APP_DIR="$SELFHOSTYOURTECH_ROOT/apps/$app"
    cd "$APP_DIR"
    docker compose logs -f --no-color 2>&1 | sed "s/^/[$app] /"
}

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

function run #description 'Run the docker compose stack'
{   
    create_traefik_public_network
    IFS=$'\n\t'        # Safer word splitting
    DEBUG="false"

    echo "Starting apps from managed-apps..."

    APP_LIST=$(sed -n '/^apps:/,/^[^ ]/p' "$APPS_ENABLED_FILE" | grep '-' | sed -e 's/- //' -e 's/^[ \t]*//' -e 's/[ \t]*$//')

    # Deploy apps
    for app in $APP_LIST; do
        APP_DIR="$SELFHOSTYOURTECH_ROOT/apps/$app"
        echo "Deploying $app in $APP_DIR..."

        APP_DIR="$SELFHOSTYOURTECH_ROOT/apps/$app"

        if [ ! -d "$APP_DIR" ]; then
            echo "❌ Directory '$app' not found. Skipping."
            exit 1
        fi

        (cd "$APP_DIR" && docker compose up -d) || {
            echo "❌ Failed to deploy $app."
            exit 1
        }
    done

    if [[ "$DEBUG" == "true" ]]; then
        echo "✅ All apps deployed. Tailing logs..."
        # Stream logs for each app in background
        for app in $APP_LIST; do
            tail_logs "$app" &
        done

        wait  # Keep script running to stream logs
    fi

}

function manage #description 'Manage stacks one by one'
{
    echo "$@"
    cd "$SELFHOSTYOURTECH_ROOT"/apps/"$1"
    shift
    docker compose $@
}
