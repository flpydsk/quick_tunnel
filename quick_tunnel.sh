#!/usr/bin/env bash
# Licensed under the Unlicense.
# FloppyDisk 2024, https://github.com/flpydsk/quick_tunnel.git

tunnel_options+=($@)
if [[ "${#tunnel_options[@]}" == "0" ]]
then
  tunnel_options+=("--hello-world")
fi

if [[ "$tunnel_options" != *"--edge-ip-version"* ]]
then
  tunnel_options+=("--edge-ip-version" "6")
fi

quick_tunnel="$(curl --silent https://api.trycloudflare.com/tunnel -X POST -H "Content-Type: application/json")"
tunnel_token="$(echo "$quick_tunnel" | jq '{a: .result.account_tag, t: .result.id, s: .result.secret}' -c | base64 -w0)"
tunnel_host="$(echo "$quick_tunnel" | jq '.result.hostname' -r)"

echo -e "\n\n\nHost  : $tunnel_host\nToken : $tunnel_token\n\n\n"

cloudflared tunnel ${tunnel_options[@]} run --token "$tunnel_token"
