#!/usr/bin/env bash

# Licensed under the Unlicense.
# (C) FloppyDisk 2024, https://github.com/flpydsk/quick_tunnel.git

edge_ip_version="6"
if [[ "$1" == "4" ]]
then
  edge_ip_version="4"
fi

quick_tunnel="$(curl --silent https://api.trycloudflare.com/tunnel -X POST -H "Content-Type: application/json")"
tunnel_token="$(echo "$quick_tunnel" | jq '{a: .result.account_tag, t: .result.id, s: .result.secret}' -c | base64 -w0)"
echo -e "\n\n\nHostname: $(echo "$quick_tunnel" | jq '.result.hostname' -r)\n\n\n"
cloudflared tunnel --edge-ip-version "$edge_ip_version" --hello-world  run --token "$tunnel_token"
