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

function setup_letsencrypt #description 'Set up Lets Encrypt certificates for Traefik'
{
    # Check if domain and email are provided
    if [ $# -lt 2 ]; then
        echo "Usage: $0 setup_letsencrypt <domain> <email> [username] [password]"
        echo "Example: $0 setup_letsencrypt yourdomain.com admin@yourdomain.com admin securepassword"
        return 1
    fi

    DOMAIN=$1
    EMAIL=$2
    USERNAME=${3:-admin}
    PASSWORD=${4:-$(openssl rand -base64 12)}
    
    # Define paths based on the project structure
    TRAEFIK_DIR="$SELFHOSTYOURTECH_ROOT/apps/traefik"
    LETSENCRYPT_DIR="$TRAEFIK_DIR/letsencrypt"
    LOGS_DIR="$TRAEFIK_DIR/logs"
    DOCKER_COMPOSE_PATH="$TRAEFIK_DIR/docker-compose.yml"
    
    # Create necessary directories
    mkdir -p "$LETSENCRYPT_DIR"
    mkdir -p "$LOGS_DIR"
    touch "$LOGS_DIR/access.log"
    
    # Set proper permissions
    chmod 600 "$LETSENCRYPT_DIR"
    chmod 600 "$LOGS_DIR/access.log"
    
    # Create .env file with configuration
    cat > "$TRAEFIK_DIR/.env" << EOF
TRAEFIK_HOST=${DOMAIN}
TRAEFIK_USER_AUTH=$(htpasswd -nb ${USERNAME} ${PASSWORD} | sed -e s/\\$/\\$\\$/g)
EOF
    
    echo "Created .env file with the following settings:"
    echo "TRAEFIK_HOST: ${DOMAIN}"
    echo "Username: ${USERNAME}"
    echo "Password: (generated securely)"
    
    # Create or ensure the existence of the network
    docker network create traefik-public 2>/dev/null || true
    echo "Ensured 'traefik-public' network exists"
    
    # Check if acme.json exists, if not create it with proper permissions
    if [ ! -f "$LETSENCRYPT_DIR/acme.json" ]; then
        touch "$LETSENCRYPT_DIR/acme.json"
        chmod 600 "$LETSENCRYPT_DIR/acme.json"
        echo "Created acme.json file with proper permissions"
    fi
    
    # Update the docker-compose.yml with the correct email if it exists
    if [ -f "$DOCKER_COMPOSE_PATH" ]; then
        sed -i "s|--certificatesresolvers.letsencrypt.acme.email=.*|--certificatesresolvers.letsencrypt.acme.email=${EMAIL}|" "$DOCKER_COMPOSE_PATH"
        echo "Updated docker-compose.yml with your email: ${EMAIL}"
    else
        echo "Warning: docker-compose.yml not found at $DOCKER_COMPOSE_PATH"
        echo "You'll need to manually update your email address in the Traefik configuration."
    fi
    
    cat << EOL

=======================================================
Let's Encrypt setup complete! Next steps:

1. Start or restart your Traefik service:
   $0 manage traefik up -d

2. Check logs to verify certificate issuance:
   $0 manage traefik logs -f

3. Access your Traefik dashboard at:
   https://${DOMAIN}

   Login with:
   - Username: ${USERNAME}
   - Password: ${PASSWORD}

4. Your certificates will be stored in:
   $LETSENCRYPT_DIR/acme.json

Note: The first time you access a domain, Traefik will
automatically request a certificate from Let's Encrypt.
=======================================================

EOL
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
