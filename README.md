# SelfHostYour.Tech Documentation

## Overview

SelfHostYour.Tech is an all-in-one Docker kit designed to help businesses self-host their complete tech stack. It's specifically tailored for companies with 1 to 100 employees who want to maintain control over their data and services.

**Important Links:**
- Main Site: [https://selfhostyour.tech](https://selfhostyour.tech)
- Source Code: [https://github.com/Monadical-SAS/selfhostyourtech](https://github.com/Monadical-SAS/selfhostyourtech)
- Community: [https://selfhostyour.org](https://selfhostyour.org)

## Getting Started

### DNS Configuration

To properly set up the DNS for this, you need to configure the following records in your domain's DNS settings:

1. **A Record**:
   - Create an A record for the root domain (e.g., `example.com`)
   - Point this record to your server's IP address

2. **Wildcard CNAME Record**:
   - Create a CNAME record with `*` as the hostname
   - Point this record to the value of your A record (e.g., `example.com`)


| Record Type | Hostname | Value/Points To |
|-------------|----------|----------------|
| A           | example.com | 10.34.2.1 (Your server IP) |
| CNAME       | * | example.com |

This configuration ensures that both the root domain and all subdomains resolve to your server.

### Quickstart

Get up and running in minutes with our automated installer that configures everything with sensible defaults.

1. Clone the repository (recommended location is `/opt`):
   ```bash
   cd /opt
   git clone https://github.com/Monadical-SAS/selfhostyourtech.git
   cd selfhostyourtech
   ```

2. Quickstart (Ubuntu only):
   ```bash
   ./bin/shtool quickstart <domain> <email> <traefik_username> <traefik_password>
   ```

### Detailed Installation

1. Clone the repository (recommended location is `/opt`):
   ```bash
   cd /opt
   git clone https://github.com/Monadical-SAS/selfhostyourtech.git
   ```

2. Install Docker (Ubuntu only):
   ```bash
   cd /opt/selfhostyourtech
   ./bin/shtool install_docker
   ```

3. Configure Let's Encrypt for SSL certificates:
   ```bash
   docker compose run --rm manager shtool setup_letsencrypt <domain> <email> [traefik_username] [traefik_password] [environment]
   ```
   
   Parameters:
   - `<domain>`: Your domain name (required)
   - `<email>`: Email for Let's Encrypt notifications (required)
   - `[username]`: Admin username (optional, defaults to "admin")
   - `[password]`: Admin password (optional, auto-generated if not specified)
   - `[environment]`: Environment type - "prod" or "dev" (optional, defaults to "prod")
   
   Example:
   ```bash
   docker compose run --rm manager shtool setup_letsencrypt example.com admin@example.com myadmin mysecurepass prod
   ```
   Note: If password is omitted, a secure random password will be generated.

4. Configure your apps by editing the enabled apps file (optional):
   ```bash
   nano /opt/selfhostyourtech/etc/apps-enabled.yaml
   ```

5. Configure application settings including credentials and passwords:
   ```bash
   docker compose run --rm manager shtool configure_app_settings
   ```
   This interactive tool will help you set up passwords, credentials, and other important settings for all enabled applications.

6. Update the Homer dashboard to reflect your enabled apps (optional):
   ```bash
   docker compose run --rm manager shtool update_homer_config
   ```

7. Deploy your selected apps:
   ```bash
   docker compose up -d
   ```

## Environment Configuration

SelfHostYour.Tech supports two deployment environments:

### Production Environment (prod)
- **HTTPS enabled**: All services use SSL/TLS certificates from Let's Encrypt
- **Secure redirects**: HTTP traffic is automatically redirected to HTTPS
- **Full SSL validation**: Complete certificate chain validation
- **Recommended for**: Live deployments, production use

### Development Environment (dev)
- **HTTP only**: Services run without SSL certificates
- **No redirects**: Direct HTTP access without HTTPS enforcement
- **Local development**: Suitable for localhost testing
- **Recommended for**: Testing, development, local setups

The environment is configured during the `setup_letsencrypt` step and affects all services automatically.

## Starting/Stopping/Status Services

```bash
docker compose exec -ti manager shtool start
docker compose exec -ti manager shtool stop
docker compose exec -ti manager shtool start <service>
docker compose exec -ti manager shtool stop <service>
docker compose exec -ti manager shtool status
docker compose exec -ti manager shtool reload
```

## Managing Services by Docker Compose wrapper

You can manage individual services using the `shtool manage` command followed by the service name and docker-compose command:

```bash
docker compose run --rm manager shtool manage <service_name> <command>
```

Examples:
- Check service status: `docker compose run --rm manager shtool manage nextcloud ps`
- Stop a service: `docker compose run --rm manager shtool manage zulip stop`
- Start a service: `docker compose run --rm manager shtool manage nextcloud up -d`
- View logs: `docker compose run --rm manager shtool manage ghost logs -f`

## Deployment Management

### Deploy Individual Services

Deploy or redeploy a specific service:
```bash
docker compose run --rm manager shtool deploy <service_name> [force_rebuild]
docker compose run --rm manager shtool redeploy <service_name> [force_rebuild]
```

Examples:
```bash
# Deploy Nextcloud
docker compose run --rm manager shtool deploy nextcloud

# Redeploy with forced rebuild
docker compose run --rm manager shtool redeploy nextcloud true
```

### Deploy All Services

Redeploy all enabled services:
```bash
docker compose run --rm manager shtool redeploy_all [force_rebuild]
```

Example:
```bash
# Redeploy all services with forced rebuild
docker compose run --rm manager shtool redeploy_all true
```

## Data Management and Cleanup

### Clean All Data
**⚠️ WARNING: This will permanently delete ALL data**

```bash
docker compose run --rm manager shtool clean
```

This command will:
- Stop all services
- Remove all Docker volumes
- Require confirmation with a randomly generated code

### Clean Individual Service Data
**⚠️ WARNING: This will permanently delete data for the specified service**

```bash
docker compose run --rm manager shtool clean_app <service_name>
```

Example:
```bash
docker compose run --rm manager shtool clean_app nextcloud
```

### Application Configuration

Configure all applications at once:
```bash
docker compose run --rm manager shtool configure_app_settings
```

Configure a single application:
```bash
docker compose run --rm manager shtool configure_app <app_name>
```

Example:
```bash
docker compose run --rm manager shtool configure_app nextcloud
```

This will launch a configuration script specifically for the selected application, allowing you to set or update:
- Admin credentials
- Database settings
- Storage paths
- Integration options
- Application-specific parameters

## For zulip

Use this command to create the organization.

```bash
cd ./apps/zulip
docker compose exec -u zulip zulip /home/zulip/deployments/current/manage.py generate_realm_creation_link
```

## For Authentik

Use this url to access the admin settings.

https://authentik.<your_domain>/if/flow/initial-setup/

## Available Services

### Communication
- **Zulip**
  - Description: Team chat with threaded conversations
  - Type: Chat Platform

### Office
- **Nextcloud**
  - Description: File sharing and collaboration platform
  - Type: Nextcloud

- **ONLYOFFICE**
  - Description: Online document editing suite
  - Type: Document Editor

- **HedgeDoc**
  - Description: Collaborative markdown editor
  - Type: Documentation

### CRM & Data
- **Baserow**
  - Description: No-code database & CRM solution
  - Type: Database/CRM

- **Twenty**
  - Description: Modern CRM platform
  - Type: CRM

### Security
- **Authentik**
  - Description: Identity provider & SSO solution
  - Type: Identity Management

- **Traefik**
  - Description: Reverse proxy & SSL management
  - Type: Traefik

### Publishing
- **Ghost**
  - Description: Professional publishing platform
  - Type: CMS

### System
- **Homer**
  - Description: Homepage dashboard
  - Type: System Dashboard

## Coming Soon
The following services are in development or planned for future releases:

- ArchiveBox - Web archiving tool
- Databox - Analytics platform
- Duplicati - Backup solution
- And more...

## Troubleshooting

### Common Issues

- **Service doesn't start**: Check logs with `docker compose run --rm manager shtool manage <service> logs`
- **Can't access service**: Verify Traefik configuration and DNS settings
- **SSL certificate problems**: Run `docker compose run --rm manager shtool setup_letsencrypt` again
- **Incorrect credentials**: Reconfigure application settings with `docker compose run --rm manager shtool configure_app_settings`
- **Configuration issues**: Check application-specific configuration files in the service directory
- **Environment mismatch**: Ensure your environment (prod/dev) is correctly configured

### Environment-Specific Issues

**Production Environment:**
- Verify domain DNS is pointing to your server
- Ensure ports 80 and 443 are open and accessible
- Check Let's Encrypt certificate generation in Traefik logs

**Development Environment:**
- Services will be accessible via HTTP only
- Use `localhost` or your local IP address
- No SSL certificates required

## Best Practices

1. Regularly back up your data
2. Keep the system updated with `git pull` in the repository directory
3. Monitor system resources to ensure adequate capacity
4. Implement proper security measures and network isolation
5. Set up monitoring for critical services
6. Use production environment for live deployments
7. Test changes in development environment first

## Support and Community

Join our Zulip community at [https://zulip.selfhostyour.tech](https://zulip.selfhostyour.tech) for support, discussions, and to connect with other users.

For bug reports and feature requests, please use the GitHub repository at [https://github.com/Monadical-SAS/selfhostyourtech](https://github.com/Monadical-SAS/selfhostyourtech). 

## Table of Contents

- [Authentik](#authentik)
- [Ghost](#ghost)
- [HedgeDoc](#hedgedoc)
- [Nextcloud](#nextcloud)
- [ONLYOFFICE](#onlyoffice)
- [Traefik](#traefik)
- [Twenty](#twenty)
- [Zulip](#zulip)

## Authentik

| Variable | Description | Default |
|----------|-------------|---------|
| `PG_DB` | PostgreSQL database name | `traefik` |
| `PG_USER` | PostgreSQL username | `traefik` |
| `PG_PASS` | PostgreSQL password | *Required* |
| `AUTHENTIK_SECRET_KEY` | Secret key for sessions & encryption | *Required* |
| `AUTHENTIK_LISTEN__HTTP` | HTTP listen address and port | `0.0.0.0:9000` |
| `AUTHENTIK_LISTEN__HTTPS` | HTTPS listen address and port | `0.0.0.0:9443` |
| `SMTP_HOST` | SMTP server address | *Optional* |
| `SMTP_USERNAME` | SMTP server username | *Optional* |
| `SMTP_PASSWORD` | SMTP server password | *Optional* |
| `EMAIL_FROM` | Email sender address | *Optional* |

## Ghost

| Variable | Description | Default |
|----------|-------------|---------|
| `MYSQL_DATABASE` | MySQL database name | `nextcloud` |
| `MYSQL_USER` | MySQL username | `nextcloud` |
| `MYSQL_ROOT_PASSWORD` | MySQL root password | *Required* |
| `MYSQL_PASSWORD` | MySQL user password | *Required* |

## HedgeDoc

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_USER` | PostgreSQL username | `hedgedoc` |
| `POSTGRES_DB` | PostgreSQL database name | `hedgedoc` |
| `POSTGRES_PASSWORD` | PostgreSQL password | *Required* |
| `HD_SESSION_SECRET` | Session encryption key | *Required* |

## Nextcloud

| Variable | Description | Default |
|----------|-------------|---------|
| `MYSQL_DATABASE` | MySQL database name | `nextcloud` |
| `MYSQL_USER` | MySQL username | `nextcloud` |
| `MYSQL_ROOT_PASSWORD` | MySQL root password | *Required* |
| `MYSQL_PASSWORD` | MySQL user password | *Required* |
| `TRUSTED_PROXIES` | Allowed proxy IP ranges | `172.0.0.0/8` |

## ONLYOFFICE

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_DB` | PostgreSQL database name | `onlyoffice` |
| `POSTGRES_USER` | PostgreSQL username | `onlyoffice` |
| `REDIS_PASSWORD` | Redis password | *Required* |
| `DB_PASSWORD` | Database password | *Required* |
| `JWT_SECRET` | JWT token secret key | *Required* |

## Traefik

| Variable | Description | Default |
|----------|-------------|---------|
| `TRAEFIK_USER_AUTH` | HTTP Basic Auth credentials | *Required* |
| `EMAIL` | Email for Let's Encrypt | *Required* |

## Twenty

| Variable | Description | Default |
|----------|-------------|---------|
| `PG_DATABASE_USER` | PostgreSQL username | *Required* |
| `PG_DATABASE_PASSWORD` | PostgreSQL password | *Required* |
| `PG_DATABASE_HOST` | PostgreSQL host | *Required* |
| `PG_DATABASE_PORT` | PostgreSQL port | *Required* |
| `SERVER_URL` | Public URL for the server | *Required* |
| `REDIS_URL` | Redis connection URL | *Required* |
| `STORAGE_TYPE` | Storage type (local/S3) | *Required* |
| `STORAGE_S3_REGION` | S3 region | *Optional* |
| `STORAGE_S3_NAME` | S3 bucket name | *Optional* |
| `STORAGE_S3_ENDPOINT` | S3 endpoint URL | *Optional* |
| `APP_SECRET` | Application secret key | *Required* |
| `EMAIL_FROM_ADDRESS` | Sender email address | *Optional* |
| `EMAIL_FROM_NAME` | Sender name | *Optional* |
| `EMAIL_SYSTEM_ADDRESS` | System email address | *Optional* |
| `EMAIL_DRIVER` | Email driver (SMTP/etc.) | *Optional* |
| `EMAIL_SMTP_HOST` | SMTP server host | *Optional* |
| `EMAIL_SMTP_PORT` | SMTP server port | *Optional* |
| `EMAIL_SMTP_USER` | SMTP username | *Optional* |
| `EMAIL_SMTP_PASSWORD` | SMTP password | *Optional* |

## Zulip

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_DB` | PostgreSQL database name | *Required* |
| `POSTGRES_USER` | PostgreSQL username | *Required* |
| `POSTGRES_PASSWORD` | PostgreSQL password | *Required* |
| `MEMCACHED_PASSWORD` | Memcached password | *Required* |
| `REDIS_PASSWORD` | Redis password | *Required* |
| `RABBITMQ_USER` | RabbitMQ username | *Required* |
| `RABBITMQ_PASSWORD` | RabbitMQ password | *Required* |
| `EMAIL_HOST` | SMTP server host | *Optional* |
| `EMAIL_HOST_USER` | SMTP username | *Optional* |
| `EMAIL_HOST_PASSWORD` | SMTP password | *Optional* |
| `EMAIL_PORT` | SMTP port | *Optional* |
| `NOREPLY_EMAIL` | No-reply email address | *Optional* |
| `ZULIP_SECRET_KEY` | Secret key for Zulip | *Required* |
| `GIPHY_API_KEY` | Giphy integration API key | *Optional* |
| `VIDEO_ZOOM_CLIENT_ID` | Zoom Client ID | *Optional* |
| `VIDEO_ZOOM_CLIENT_SECRET` | Zoom Client Secret | *Optional* |
| `SOCIAL_AUTH_OIDC_SECRET` | OIDC authentication secret | *Optional* |
