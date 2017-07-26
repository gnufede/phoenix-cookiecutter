#!/bin/sh

/usr/local/bin/mix phx.new /opt/app/$PROJ_NAME
cd /opt/app/$PROJ_NAME/assets && npm install && node node_modules/brunch/bin/brunch build
