#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o noclobber

gunzip -c "${1}" \
  | docker-compose exec -T db bash -c "mysql -u root -psomewordpress wordpress"
