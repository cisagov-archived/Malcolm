#!/usr/bin/env bash

# htadmin also runs with keycloak selected as the auth mode, as the OpenSearch API endpoint is not (yet) compatible
if [[ "${NGINX_AUTH_MODE:-basic}" =~ ^(true|basic|keycloak|keycloak_remote)$ ]]; then

  if [[ ! -f /var/www/htadmin/config/config.ini ]] && [[ -f /var/www/htadmin/default/config.ini ]]; then
    cp /var/www/htadmin/default/config.ini /var/www/htadmin/config/config.ini
    [[ -n ${PUID} ]] && chown -f ${PUID} /var/www/htadmin/config/config.ini
    [[ -n ${PGID} ]] && chown -f :${PGID} /var/www/htadmin/config/config.ini
  fi

  if [[ ! -f /var/www/htadmin/config/metadata ]] && [[ -f /var/www/htadmin/default/metadata ]]; then
    cp /var/www/htadmin/default/metadata /var/www/htadmin/config/metadata
    [[ -n ${PUID} ]] && chown -f ${PUID} /var/www/htadmin/config/metadata
    [[ -n ${PGID} ]] && chown -f :${PGID} /var/www/htadmin/config/metadata
  fi

  sleep 10
  nginx -g "daemon off;"

else
  /usr/local/bin/service_check_passthrough.sh -d -s htadmin -p 80 -f http
fi
