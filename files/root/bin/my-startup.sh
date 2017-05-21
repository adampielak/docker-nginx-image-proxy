#!/bin/bash
function die {
   echo >&2 "$@"
   exit 1
}

#######################################
# Echo/log function
# Arguments:
#   String: value to log
#######################################
function log {
   if [[ "$@" ]]; then echo "[`date +'%Y-%m-%d %T'`] $@";
   else echo; fi
}

if [ -n "$SERVER_CONF" ] ; then
   log "Getting new server conf"
   mv /etc/nginx/sites-enabled/server.conf /etc/nginx/sites-enabled/server.bak
   curl -SL $SERVER_CONF --output /etc/nginx/sites-enabled/server.conf
fi

if [ -n "$GEODB_URL" ] ; then
   log "Updating geo db"
   curl $GEODB_URL | gzip -d - > /etc/nginx/GeoLiteCity.dat
fi

nginx -t || true
