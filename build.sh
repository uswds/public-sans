#!/bin/sh

if [ ! -d "node_modules/uswds/dist" ]; then
  npm run uswds-install && npm run uswds-build
fi
