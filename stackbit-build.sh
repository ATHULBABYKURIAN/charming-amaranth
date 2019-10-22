#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5daee3b657ad0c001bb578c5/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5daee3b657ad0c001bb578c5 
fi
curl -s -X POST https://api.stackbit.com/project/5daee3b657ad0c001bb578c5/webhook/build/ssgbuild > /dev/null
make prepare && hugo --source demo --baseURL "/"
./inject-netlify-identity-widget.js demo/public
curl -s -X POST https://api.stackbit.com/project/5daee3b657ad0c001bb578c5/webhook/build/publish > /dev/null
