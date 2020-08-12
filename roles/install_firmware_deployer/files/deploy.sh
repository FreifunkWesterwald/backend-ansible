#!/bin/sh
set -e

BASEDIR=$(pwd)
UNSTABLE=0
DESTINATION=unset

usage() {
  echo "Usage $0 [ -u | --unstable ] [ -d= | --destination= ] [ -h | --help ]
       Deploys the firmware to the web directory.
       If '-u' or '--unstable' is given, the pre-release from './prepare/unstable' is deployed. Otherwise './prepare/stable' will be deployed.
       If '-d' or '--destination' must be given and denotes the base directory where the stable/unstable firmware shall be deployed (e.g. '/var/www/freifunk-westerwald.de/firmware').
       If '-h' or '--help' is given, this message is printed."

  exit 2
}


PARSED_ARGUMENTS=$(getopt -a -n alphabet -o hud: --long help,unstable,destination: -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

eval set -- "$PARSED_ARGUMENTS"
while :
do
  case "$1" in
    -u | --unstable)    UNSTABLE=1      ; shift   ;;
    -d | --destination) DESTINATION=$2  ; shift 2 ;;
    -h | --help) usage ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    # If invalid options were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

if [ "$DESTINATION" = "unset" -o -z "$DESTINATION" ]; then
  echo 'option -d | --destination requires an argument'
  exit 1
fi

if [ ! -d "$DESTINATION" ]; then
  echo "destination directory '$DESTINATION' does not exist."
  exit 1
fi

if [ $UNSTABLE -eq 1 ]; then
  BRANCH_NAME=unstable
else
  BRANCH_NAME=stable
fi

if [ ! -d $BASEDIR/prepare/$BRANCH_NAME/images ]; then
  echo "Images directory '$BASEDIR/prepare/$BRANCH_NAME/images' missing. Run ./prepare.sh first?"
  exit 1
fi

echo deploying
rsync -a --delete $BASEDIR/prepare/$BRANCH_NAME/images/* $DESTINATION/$BRANCH_NAME/
echo deployment done
