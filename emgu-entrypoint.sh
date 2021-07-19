#!/bin/bash
set -e

echo "Preparing to start Damselfly...."
echo "  ./EmguCVSample"

LD_DEBUG=libs ./EmguCVSample > /config/LD_DEBUG.log

./EmguCVSample > /config/emgucv.log

exec "$@"
