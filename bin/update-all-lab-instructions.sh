#!/usr/bin/env bash

export QWIKLABS_REPO_DIR="$1"

usage() {
  echo "$(basename $0) /path/to/qwiklabs/repo"
}

# Check arguments
if [ ! -d "${QWIKLABS_REPO_DIR}" ] ; then
  echo "ERROR: QWIKLABS_REPO_DIR is required." && usage && exit 1;
fi

./update-lab-instructions.sh  "${QWIKLABS_REPO_DIR}" enbl007 15hofQmOqNVO3IxquS3sAKDmUYJ5ju9Yq6l4gM7nCLpI
./update-lab-instructions.sh  "${QWIKLABS_REPO_DIR}" enbl008 1pMq49viVv0IF81GRIEoGnjeigfwUAmAZvaKbmNH_Syk
./update-lab-instructions.sh  "${QWIKLABS_REPO_DIR}" enbl009 12NNwHC8FAJjvNnwSqPRIv78fG-tuR9i6PeE5MIiYflI
./update-lab-instructions.sh  "${QWIKLABS_REPO_DIR}" enbl010 1uHagPCFGZmDrYUsONW8WNZsK18jGWrhC1iDRHPqNBiI
./update-lab-instructions.sh  "${QWIKLABS_REPO_DIR}" enbl011 10TmdRsD2yZddpRZlA3M06BrmsdsQjJgga7pujW-Jhwk
./update-lab-instructions.sh  "${QWIKLABS_REPO_DIR}" enbl012 1GtlPbFKCo4MtGTb3moCvxWaug_LqBOO_TsPp0dVaXng


