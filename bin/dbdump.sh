#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o noclobber

declare -r SCRIPT_DIR_PATH="$(dirname "$(readlink -f "$0")")"

cd "$(dirname "${SCRIPT_DIR_PATH}")"

docker-compose exec -T db bash -c "mysqldump -u root -psomewordpress wordpress 2>/dev/null \
  | gzip -c" >$(date +%Y%m%d-%H%M).dump.gz
