#!/bin/bash
set -e

echo "Preparing to start Damselfly...."
echo "  ./EmguCVSample"

LD_DEBUG_OUTPUT=/config/LD_DEBUG.log LD_DEBUG=libs ./EmguCVSample

./EmguCVSample > /config/emgucv.log

exec "$@"
