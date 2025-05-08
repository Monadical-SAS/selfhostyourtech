openssl rand -base64 32
docker compose exec -ti -u=zulip zulip /home/zulip/deployments/current/manage.py generate_realm_creation_link
