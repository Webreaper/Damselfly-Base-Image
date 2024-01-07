#!/bin/bash

echo "=== Starting Cleanup"

apt-get update
apt-get remove -y build-essential git curl make perl

echo "=== Completed Cleanup."
