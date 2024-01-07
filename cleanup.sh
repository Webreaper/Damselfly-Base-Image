#!/bin/bash

echo "=== Starting Cleanup"

apt-get update
apt-get remove build-essential git curl make perl

echo "=== Completed Cleanup."
