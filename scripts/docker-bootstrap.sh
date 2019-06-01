#!/bin/sh

echo "Y" > /tmp/yes
/usr/local/bin/mix phx.new /opt/app/$PROJ_NAME < /tmp/yes
rm /tmp/yes
cd /opt/app/$PROJ_NAME/assets && npm install && node node_modules/webpack/bin/webpack.js --mode development
