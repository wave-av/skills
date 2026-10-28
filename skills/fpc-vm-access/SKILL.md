---
name: fpc-vm-access
description: >-
  Use when a task needs a shell or a read-only check on a CI guest VM (registry,
  router, or a CI slot). Read it before opening a session on the operator
  workstation.
---
# Reach a CI guest VM

The route is fixed. Use the helper. Do not rediscover it, and do not paste addresses, host names, or account names into chat, tickets, or this skill.

1. Work from the operator workstation that can reach the CI host. The bot computer often cannot reach the lab network. Each command there may raise an approval prompt, so batch the work.
2. In the CI tooling checkout on that workstation, run `bin/fpc-vm-ssh --check <vm>`. It checks address, SSH key, host reachability, guest power state, and port 22, read-only, and prints PASS or FAIL per step.
3. If every step passes, run the work as one command: `bin/fpc-vm-ssh <vm> -- <command>`. Static commands only. Never splice a secret into argv.
4. Unknown guest: `bin/fpc-vm-ssh --list`, take the address from the host's own inventory, pass `--ip`, and open a pull request that adds the guest to the known-address list. Do not copy that address into this skill.

Login uses the workstation SSH key. The host user and the guest user are the ones that key is for, not a secret-manager login. The secret manager supplies payload secrets by name. Send those over SSH stdin, never in argv, and never print them.

Failure map: if the host is unreachable, it is asleep or off the network. Use the current host name from the runbook, not a retired one. If the guest is not running, report that and do not start or rebuild VMs without a ticket. If the host key does not match, stop and report it. Never delete the pin to get past it.

If the route changes, update the runbook, this skill, and the helper in the same change.
