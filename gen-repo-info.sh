#!/bin/bash -e
# Generate indentifying information about the checked out git repo which was
# used for the built charm. The resulting repo-info file will be present in
# cs: artifacts and /var/lib/juju artifacts on disk within units.
echo "commit-sha-1: $(git rev-parse HEAD)
commit-short: $(git rev-parse --short HEAD)
branch: $(git rev-parse --abbrev-ref HEAD)
remote: $(git config --get remote.origin.url)
info-generated: $(date -u)
note: This file should exist only in a built or released charm artifact (not in the charm source code tree)." | tee repo-info
