#!/usr/bin/env fish

set -x NIX_SSHOPTS "-i /etc/nixos/secrets/legion-5/ssh/legion-5_admin@Nasys"
nixos-rebuild switch --target-host admin@nasys.servers.stasaitis.me --flake .#Nasys --impure --build-host admin@nasys.servers.stasaitis.me --ask-sudo-password
