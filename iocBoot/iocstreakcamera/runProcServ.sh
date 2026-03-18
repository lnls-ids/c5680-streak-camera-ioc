#!/bin/sh

set -e
set +u

# Parse command-line options
. ./parseOPTArgs.sh "$@"

set -u

# Run run*.sh scripts with procServ
procServ -f -n SC5680_${DEVICE} -i ^C^D unix:./procserv.sock ./startup.sh "$@"
