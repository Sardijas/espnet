#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

. ./path.sh || exit 1;
. ./cmd.sh || exit 1;
. ./db.sh || exit 1;

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
help_message=$(cat << EOF
Usage: $0
Options:
    --remove_archive (bool): true or false
      With remove_archive=True, the archives will be removed after being successfully downloaded and un-tarred.
EOF
)

SECONDS=0
stage=1
stop_stage=100

. utils/parse_options.sh || exit 1;

data_url=https://drive.google.com/file/d/1uhYY48hO3N_swX25mgU6bmYGRTO2bf5x
output="atis_data"
remove_archive=false
download_opt=

if "$remove_archive"; then
  download_opt="--remove-archive"
fi

if [ -z "${ATIS}" ]; then
  log "Error: \$ATIS is not set in db.sh."
  exit 2
fi


if [ ! -d "${ATIS}" ]; then
    mkdir -p "${ATIS}"
fi

if [ ${stage} -le 0 ] && [ ${stop_stage} -ge 0 ]; then 
    log "stage1: Download data to ${ATIS}"
    	
    data = ${ATIS}
    part = "atis_data"

    if [ -f $data/$part/.complete ]; then
       echo "$0: data part $part was already successfully extracted, nothing to do."
       exit 0;
    fi
 
    gdown.download(data_url, output, quiet=False);
    cd $data || exit 1

    if ! tar -xvzf $part.tgz; then
       echo "$0: error un-tarring archive $data/$part.tgz"
       exit 1;
    fi

    echo "$0: Successfully downloaded and un-tarred $data/$part.tgz"

    if $remove_archive; then
       echo "$0: removing $data/$part.tgz file since --remove-archive option was supplied."
       rm $data/$part.tgz
    fi
fi

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    log "stage2: data preparation"
     


	
    mkdir -p data/train data/dev data/test

    

