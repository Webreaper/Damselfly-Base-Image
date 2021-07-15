#!/bin/bash
set -e

echo "Preparing to start Damselfly...."
echo "  ./EmguCVSample"

./EmguCVSample > /config/emgucv.log

exec "$@"
