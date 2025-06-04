#!/bin/bash

set -e

SCRIPTS_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SELFHOSTYOURTECH_ROOT="$( dirname "$SCRIPTS_ROOT")"
echo "$SCRIPTS_ROOT"
echo "$SELFHOSTYOURTECH_ROOT"

branch=${1-main}

eval "$(ssh-agent -s)"
ssh-add /root/.ssh/monadical.key
cd "$SELFHOSTYOURTECH_ROOT" || exit 1
git checkout "$branch" || exit 1
git pull --autostash origin "$branch"
docker compose up -d
docker compose exec -ti manager shtool "redeploy_all" "false"
