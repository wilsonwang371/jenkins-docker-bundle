#!/bin/bash

set -x

echo "starting webmin service..."
service webmin start

echo "starting jenkins..."
/sbin/tini -- /usr/local/bin/jenkins.sh "$@"
