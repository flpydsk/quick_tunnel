#!/usr/bin/env bash
# Licensed under the Unlicense.
# FloppyDisk 2024, https://github.com/flpydsk/quick_tunnel.git
#Runs a quick tunnel with a config.yml in this directory

current_dir="$(dirname "$0")"
if [[ ! -f "$current_dir/config.yml" ]]
then
  echo "You need a config.yml for this, Using the example"
  cp "$current_dir/config.yml.example" "$current_dir/config.yml"
fi

tunnel_options=($@)
if [[ "$tunnel_options" != *"--edge-ip-version"* ]]
then
  tunnel_options+=("--edge-ip-version" "6")
fi

quick_tunnel="$(curl --silent https://api.trycloudflare.com/tunnel -X POST -H "Content-Type: application/json")"
tunnel_token="$(echo "$quick_tunnel" | jq '{a: .result.account_tag, t: .result.id, s: .result.secret}' -c | base64 -w0)"
tunnel_host="$(echo "$quick_tunnel" | jq '.result.hostname' -r)"

sed -i "s/  - hostname: .*/  - hostname: $tunnel_host/g" "$current_dir/config.yml"

echo -e "\n\n\nHost  : $tunnel_host\nToken : $tunnel_token\n\n\n"

cloudflared --config "$current_dir/config.yml" tunnel ${tunnel_options[@]} run --token "$tunnel_token"
