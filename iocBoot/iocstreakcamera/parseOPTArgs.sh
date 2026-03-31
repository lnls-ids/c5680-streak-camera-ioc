#!/bin/bash

# Check for uninitialized variables
# Exit on error
set -e

usage () {
    echo "Usage:" >&2
    echo "  $1 -P PREFIX -i IP_ADDR -C COMMANDS_TCP -D DATA_TCP" >&2
    echo >&2
    echo " Options:" >&2
    echo "  -P                  Configure device prefix for PV names" >&2
    echo "  -i                  Configure Streak Camera IP address" >&2
    echo "  -C                  Configure Streak Camera Commands TCP port" >&2
    echo "  -D                  Configure Streak Camera Data TCP port" >&2
}

while getopts 'P:i:C:D:' opt; do
    case "$opt" in
        P) 
            PREFIX="$OPTARG" 
            ;;
        i) 
            IP_ADDR="$OPTARG" 
            ;;
        C) 
            COMMANDS_TCP="$OPTARG" 
            ;;
        D)
            DATA_TCP="$OPTARG"
            ;;
        \?) 
            echo "Invalid -$OPTARG command option.">&2
            usage $0
            exit 1
            ;;
        :) 
            echo "Missing argument -$OPTARG">&2
            usage $0
            exit 1
            ;;
        *) 
            usage $0
            exit 1
            ;;
    esac
done

if [ "$OPTIND" -le "$#" ]; then
    echo "Invalid argument at index '$OPTIND' does not have a corresponding option." >&2
    usage $0
    exit 1
fi

if [ -z "$PREFIX" ]; then
   usage $0
   exit
fi

if [ -z "$IP_ADDR" ]; then
   usage $0
   exit
fi

if [ -z "$COMMANDS_TCP" ]; then
   COMMANDS_TCP=1001
fi

if [ -z "$DATA_TCP" ]; then
    DATA_TCP=1002
fi
