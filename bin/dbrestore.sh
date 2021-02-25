#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o noclobber

gunzip -c "${1}" \
  | docker-compose exec -T kanji_genzouw_com_db bash -c "mysql -u root -prootroot kanji_genzouw_com_db"
