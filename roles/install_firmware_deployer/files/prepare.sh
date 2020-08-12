#/bin/sh

set -e

if ! which curl >/dev/null 2>&1; then
  echo "'curl' is not installed.
  exit 1
fi

if ! which jq >/dev/null 2>&1; then
  echo "'jq' is not installed.
  exit 1;
fi

BASEDIR=$(pwd)
UNSTABLE=0
SKIP_DOWNLOAD=0

usage() {
  echo "Usage $0 [ -u | --unstable ] [ --skip-download ] [ -h | --help ]
       Pulls the most recently released firmware from github and prepares it for signing and deployment.
       If '-u' or '--unstable' is given, the latest pre-release is chosen instead of the latest release.
       If '--skip-download' is given, the release won't be (re-) downloaded. This is mainly for testing, as downloading is slow.
       If '-h' or '--help' is given, this message is printed.
       
       Files will be put into 'stable' or 'unstable' in the ./prepare directory - depending on if '-u' was given."
  exit 2
}


PARSED_ARGUMENTS=$(getopt -a -n alphabet -o hu --long help,unstable,skip-download -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

eval set -- "$PARSED_ARGUMENTS"
while :
do
  case "$1" in
    -u | --unstable)  UNSTABLE=1              ; shift   ;;
    --skip-download)  SKIP_DOWNLOAD=1         ; shift   ;;
    -h | --help) usage ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    # If invalid options were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done


if [ $UNSTABLE -eq 1 ]; then
  BRANCH_NAME=unstable
else
  BRANCH_NAME=stable
fi

if [ $SKIP_DOWNLOAD -eq 0 ]; then
  cd $BASEDIR
  mkdir -p prepare
  cd prepare
  
  rm -rf $BRANCH_NAME
  mkdir $BRANCH_NAME
  cd $BRANCH_NAME
  
  DOWNLOAD_URLS=($(
    curl -s https://api.github.com/repos/FreifunkWesterwald/site-ffww/releases | (
      if [ $UNSTABLE -eq 1 ]; then
        jq '[ .[] | select(.prerelease) ]'
      else
        jq '[ .[] | select(.prerelease == false) ]'
      fi
    ) | jq -r 'sort_by(.published_at) | reverse | .[0].assets[] | .browser_download_url'
  ))
  N_DOWNLOADS=${#DOWNLOAD_URLS[@]}
  for (( i=0; i<$N_DOWNLOADS; i++ )); do
    echo downloading $(($i + 1)) / $N_DOWNLOADS: ${DOWNLOAD_URLS[$i]}
    curl -sROL ${DOWNLOAD_URLS[$i]}
  done
fi

cd $BASEDIR
WORKPATH=prepare/$BRANCH_NAME

if [ ! -d $WORKPATH -a $SKIP_DOWNLOAD -eq 1 ]; then
  echo "$WORKPATH does not exist and --skip-download was given. Maybe consider downloading the files first?"
  exit 1
fi

cd $WORKPATH
rm -rf images
for FW_ARCHIVE in *.tar.xz
do
  echo unpacking $FW_ARCHIVE
  tar xf $FW_ARCHIVE --xform='s!.*.manifest!./manifests/'${FW_ARCHIVE/.tar.xz/}'.manifest!' ./images
done

echo generating new manifest
(
  # Header
  head -n 5 $(ls manifests/*.manifest | head -n 1)
  # Content
  ls manifests/*.manifest | xargs -n 1 tail -n +5
  # Footer (for signatures)
  echo ---
) > images/sysupgrade/$BRANCH_NAME.manifest
