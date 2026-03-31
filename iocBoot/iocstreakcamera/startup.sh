#!/bin/bash

# Exit on error
set -e

. ./parseOPTArgs.sh "$@"

if [ ! $? = 0 ]; then
	echo "Could not parse command-line options" >&2
	exit 1
fi

PREFIX="$PREFIX" IP_ADDR="$IP_ADDR" COMMANDS_TCP="$COMMANDS_TCP" DATA_TCP="$DATA_TCP" ./st.cmd
