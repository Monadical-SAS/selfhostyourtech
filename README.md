# SelfHostYour.Tech

An all-in-one Docker kit to self-host your business's tech stack.

Aimed at companies with 1 ~ 100 employees.

- Main Site: https://selfhostyour.tech
- Source Code: https://github.com/Monadical-SAS/selfhostyourtech
- Community: https://zulip.selfhostyour.tech
- Documentation: https://docs.selfhostyour.tech

---

## Installation

1. [Install Docker](https://docs.docker.com/get-docker/)
2. `git clone https://github.com/Monadical-SAS/selfhostyourtech.git /opt/selfhostyourtech`
3. ```bash
   for folder in $(ls -d /opt/selfhostyourtech/*/); do
     cd $folder
     docker compose up -d
     cd ..
   done

   # wait 1~2 min for everything to finish launching

   # then run all the scripts to link the services together
   bash ./*/bin/link_to_*.sh
   ```


<br/>

---
---

<br/>

## Services

### Communication

#### zulip ⭐️

#### simplelogin

#### stalwart

### Publishing

- hedgedoc ⭐️
- wordpress
- matomo

### Office

- hedgedoc ⭐️
- nextcloud ⭐️
- ONLYOFFICE ⭐️
- collabora
- penpot
- twenty

### Security

- authentik ⭐️
- tailscale ⭐️

### Data Warehousing

- archivebox ⭐️
- baserow ⭐️
- databox ⭐️
- duplicati ⭐️

### DevOps

- portainer ⭐️
- traefik ⭐️
- n8n ⭐️
- gitea
- healthchecks.io ⭐️

### AI

- librechat ⭐️
- helix ⭐️
- reflector ⭐️
