#!/bin/bash

set -x
set -o pipefail
set -e

trickle_feed_spleeter(){
  
  DOWNLOAD_DIR=$1
  UPLOAD_DIR=$( $DOWNLOAD_DIR | sed 's/upload/download/g')
  
  if [ -d "$DOWNLOAD_DIR" ]; then
    
    echo "Comitting to split in ${DOWNLOAD_DIR}..."
    source ~/miniconda3/etc/profile.d/conda.sh || exit 1 && echo -e "Could not initialise environment"
    conda activate spleeter-cpu
    
    cd $DOWNLOAD_DIR || echo "Temp download directory not found" && exit
    for file in *; do spleeter separate -i $file -o $UPLOAD_DIR -p spleeter:2stems; wait; done

    echo -e "SPLIT COMPLETE: WAITING FOR OUTPUT"
    echo "Please check ${UPLOAD_DIR} for many outputs"

  else

    echo "CRITICAL: ${DOWNLOAD_DIR} not found. Can not continue."
    exit 1

  fi
}

sync_to_s3(){
  sh /opt/sudjsoc-spleeter/sync_to_s3.sh ${UPLOAD_DIR}
}

trickle_feed_spleeter
sync_to_s3

set +x
