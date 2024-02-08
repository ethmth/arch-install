#!/bin/bash

source .env

while true; do
curl -s "https://us.edstem.org/api/threads/$THREAD?view=1" \
  -H 'authority: us.edstem.org' \
  -H 'accept: */*' \
  -H 'accept-language: en-US,en;q=0.7' \
  -H 'origin: https://edstem.org' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-site' \
  -H 'sec-gpc: 1' \
  -H "user-agent: $USER_AGENT" \
  -H "x-token: $AUTH_TOKEN" \
  --compressed > /dev/null
  
  sleep 1
done