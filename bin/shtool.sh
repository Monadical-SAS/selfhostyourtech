#!/bin/bash

set -e

SCRIPTS_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SELFHOSTYOURTECH_ROOT="$( dirname "$SCRIPTS_ROOT")"
APPS_ENABLED_FILE="$SELFHOSTYOURTECH_ROOT"/etc/apps-enabled.yaml

source "$SCRIPTS_ROOT/tools.sh"

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
    
    # Create necessary directories
    mkdir -p "$LETSENCRYPT_DIR"
    mkdir -p "$LOGS_DIR"
    touch "$LOGS_DIR/access.log"
    
    # Set proper permissions
    chmod 600 "$LETSENCRYPT_DIR"
    chmod 600 "$LOGS_DIR/access.log"

    BASE_DOMAIN=$(extract_domain "${DOMAIN}")
    
    # Create .env file with configuration
    cat > "$TRAEFIK_DIR/.env" << EOF
TRAEFIK_HOST=${DOMAIN}
TRAEFIK_USER_AUTH=$(htpasswd -nb ${USERNAME} ${PASSWORD} | sed -e s/\\$/\\$\\$/g)
DOMAIN=${DOMAIN}
BASE_DOMAIN=${BASE_DOMAIN}
EMAIL=${EMAIL}
EOF

    cat > "$SELFHOSTYOURTECH_ROOT/etc/basedomain.txt" << EOF
${BASE_DOMAIN}
EOF
    cat > "$SELFHOSTYOURTECH_ROOT/etc/default_admin_email.txt" << EOF
${EMAIL}
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
    
}

function deploy #description 'Deploy an specific service'
{
    local app_name=$1
    local force_rebuild=${2:-false}
    
    echo "🚀 Deploying/redeploying $app_name..."
    
    APP_DIR="$SELFHOSTYOURTECH_ROOT/apps/$app_name"
    if [ ! -d "$APP_DIR" ]; then
        echo "❌ Directory '$app_name' not found. Cannot deploy."
        return 1
    fi
    
    # Update environment variables if needed
    BASE_DOMAIN_VALUE=$(cat "$SELFHOSTYOURTECH_ROOT/etc/basedomain.txt")
    add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$APP_DIR/.env"
    
    # CD into the app directory
    cd "$APP_DIR" || return 1
    
    # Pull latest images
    echo "📥 Pulling latest images for $app_name..."
    docker compose pull
    
    # Stop the existing container(s) gracefully
    echo "🛑 Stopping existing $app_name containers..."
    (cd "$SELFHOSTYOURTECH_ROOT" && shtool stop "$app_name")
    
    # Build if forced or if images don't exist
    if [ "$force_rebuild" = true ]; then
        echo "🔨 Rebuilding $app_name..."
        docker compose build --no-cache
    fi
    
    # Start the new container(s)
    echo "🚀 Starting $app_name..."
    (cd "$SELFHOSTYOURTECH_ROOT" && shtool start "$app_name")
    
    echo "✅ $app_name deployed successfully"
    
    # Return to previous directory
    cd - > /dev/null
}

function redeploy_all #description 'Redeploy all services'
{
    local force_rebuild=${1:-false}
    
    create_traefik_public_network
    
    if [[ ! -f "$SELFHOSTYOURTECH_ROOT/etc/basedomain.txt" ]]; then
        echo "❌ Base Domain file should be created first."
        echo "Run first: shtool setup_letsencrypt"
        exit 1
    fi
    
    echo "Redeploying all apps from managed-apps..."
    
    APP_LIST=$(sed -n '/^apps:/,/^[^ ]/p' "$APPS_ENABLED_FILE" | grep '-' | sed -e 's/- //' -e 's/^[ \t]*//' -e 's/[ \t]*$//')
    
    for app in $APP_LIST; do
        deploy "$app" "$force_rebuild"
    done
    
    # Reconfigure and restart supervisor
    configure_supervisor
    supervisorctl reread && supervisorctl update
    
    echo "🎉 All applications redeployed successfully"
}

function redeploy #description 'Redeploy an specific service'
{
    local app_name=$1
    local force_rebuild=${2:-false}
    
    if [[ -z "$app_name" ]]; then
        echo "❌ You must specify an app name to redeploy."
        echo "Usage: shtool redeploy <app_name> [force_rebuild]"
        return 1
    fi
    
    echo "🔄 Redeploying $app_name..."
    deploy "$app_name" "$force_rebuild"
    
    # Reconfigure and restart supervisor for this app
    configure_supervisor
    supervisorctl reread && supervisorctl update
    supervisorctl restart "$app_name" || true
    
    echo "🎉 $app_name redeployed successfully"
}

function configure_supervisor #description 'Generate supervisor config for the different apps'
{
    APP_LIST=$(sed -n '/^apps:/,/^[^ ]/p' "$APPS_ENABLED_FILE" | grep '-' | sed -e 's/- //' -e 's/^[ \t]*//' -e 's/[ \t]*$//')
    APP_DIR="$SELFHOSTYOURTECH_ROOT/apps"
    CONF_DIR="$SELFHOSTYOURTECH_ROOT/etc/supervisor/conf.d"
    generate_supervisor_config "$APP_LIST" "$APP_DIR" "$CONF_DIR" "$SELFHOSTYOURTECH_ROOT"
}

function run #description 'Run the docker compose stack'
{   
    create_traefik_public_network

    if [[ -f "$SELFHOSTYOURTECH_ROOT/etc/basedomain.txt" ]]; then
        echo "✅ Base Domain file exists."
    else
        echo "❌ Base Domain file should be created first".
        echo "Run first: shtool setup_letsencrypt"
        exit 1
    fi

    echo "Starting apps from managed-apps..."

    APP_LIST=$(sed -n '/^apps:/,/^[^ ]/p' "$APPS_ENABLED_FILE" | grep '-' | sed -e 's/- //' -e 's/^[ \t]*//' -e 's/[ \t]*$//')

    for app in $APP_LIST; do
        APP_DIR="$SELFHOSTYOURTECH_ROOT/apps/$app"
        APP_DIR="$SELFHOSTYOURTECH_ROOT/apps/$app"
        if [ ! -d "$APP_DIR" ]; then
            echo "❌ Directory '$app' not found. Skipping."
            continue
        fi
        BASE_DOMAIN_VALUE=$(cat "$SELFHOSTYOURTECH_ROOT/etc/basedomain.txt")
        add_key_in_env "BASE_DOMAIN" "$BASE_DOMAIN_VALUE" "$APP_DIR/.env"

    done

    configure_supervisor

    supervisorctl stop all || true
    supervisorctl reread && supervisorctl update
    supervisord -c /etc/supervisor/supervisord.conf -n
}

function stop #description 'Stop an specific service'
{
    local service=${1:-all}
    supervisorctl stop "$service"
}

function start #description 'Stop an specific service'
{
    local service=${1:-all}
    supervisorctl start "$service"
}

function reload #description 'Reload services'
{
    supervisorctl stop all || true
    supervisorctl reread && supervisorctl update
    supervisorctl start all
}

function status #description 'List service statuses'
{
    supervisorctl status
}

function install_docker #description 'Install docker'
{
    # Remove any conflicting packages
    echo "Removing any conflicting packages..."
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
        sudo apt-get remove -y $pkg > /dev/null 2>&1 || true
    done
    
    # Update package index and install prerequisites
    echo "Updating package index and installing prerequisites..."
    sudo apt-get update -y
    sudo apt-get install -y ca-certificates curl
    
    # Set up Docker's apt repository
    echo "Setting up Docker repository..."
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # Add the repository to Apt sources
    echo "Adding Docker repository to apt sources..."
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Update package index again
    echo "Updating package index with Docker repository..."
    sudo apt-get update -y
    
    # Install Docker packages
    echo "Installing Docker packages..."
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Verify installation
    echo "Verifying Docker installation..."
    if sudo docker run --rm hello-world > /dev/null 2>&1; then
        echo "Docker has been successfully installed!"
    else
        echo "Docker installation may have issues. Please check the system logs."
    fi
}

function manage #description 'Manage stacks one by one'
{
    echo "$@"
    cd "$SELFHOSTYOURTECH_ROOT"/apps/"$1"
    shift
    docker compose $@
}

function configure_app #description 'Run specific app scripts for one app'
{
    local APP=$1
    APP_DIR="$SELFHOSTYOURTECH_ROOT/apps/$APP"
    run_app_hook "$APP_DIR"
}

function configure_app_settings #description 'Run specific app scripts'
{
    APP_LIST=$(sed -n '/^apps:/,/^[^ ]/p' "$APPS_ENABLED_FILE" | grep '-' | sed -e 's/- //' -e 's/^[ \t]*//' -e 's/[ \t]*$//')

    # Deploy apps
    for app in $APP_LIST; do
        APP_DIR="$SELFHOSTYOURTECH_ROOT/apps/$app"
        run_app_hook "$APP_DIR"
    done
}

function update_homer_config #description 'Update Homer Dashboard configuration'
{
    echo "Running update_homer_config.py tool ..."
    python "$SELFHOSTYOURTECH_ROOT/tools/update_homer_config.py"
}

function default_admin_email #description 'Set the default admin email'
{
    local DEFAULT_EMAIL=$1
    APP_DIR="$SELFHOSTYOURTECH_ROOT/apps"
    cat > "$SELFHOSTYOURTECH_ROOT/etc/default_admin_email.txt" << EOF
${DEFAULT_EMAIL}
EOF
}

function quickstart #description 'Quick install'
{
    if [ $# -lt 4 ]; then
        echo "Usage: $0 quickstart <domain> <email> <username> <password>"
        echo "Example: $0 quickstart yourdomain.com admin@yourdomain.com admin securepassword"
        return 1
    fi
    local domain=$1
    local email=$2
    local username=$3
    local password=$4
    install_docker
    docker compose run --rm manager shtool setup_letsencrypt "$domain" "$email" "$username" "$password"
    docker compose run --rm manager shtool configure_app_settings
    docker compose run --rm manager shtool update_homer_config
    echo "Starting selfhostyourtech stack 🎉 ..."
    docker compose up -d
}
