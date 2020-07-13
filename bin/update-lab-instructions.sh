#!/usr/bin/env bash
set -e

export QWIKLABS_REPO_DIR="$1"
export LAB_PREFIX="$2"
export GDOC_ID="$3"

function usage() {
  echo "$(basename $0) /path/to/qwiklabs/repo lab-prefix google-doc-id"
}

# Check arguments
if [ ! -d "${QWIKLABS_REPO_DIR}" ] ; then
  echo "ERROR: QWIKLABS_REPO_DIR is required." && usage && exit 1;
fi

if [ -z "${LAB_PREFIX}" ] ; then
  echo "ERROR: LAB_PREFIX is required." && usage && exit 1;
fi

if [ -z "${GDOC_ID}" ] ; then
  echo "ERROR: GDOC_ID is required." && usage && exit 1;
fi

# Make sure the conversion tool is available
if ! command -v gdoc-2-markdown.sh &> /dev/null
then
  echo "ERROR: gdoc-2-markdown.sh is not available." && exit 1;
fi

# Check that lab directory exists
export LAB_DIR=$(find  "${QWIKLABS_REPO_DIR}/labs" -type d -name "${LAB_PREFIX}*" | head -1)
echo ${LAB_DIR}
if [ ! -d "${LAB_DIR}" ]; then
  echo "ERROR: Could not locate lab with prefix ${LAB_PREFIX} in ${QWIKLABS_REPO_DIR}/labs"  && exit 1;
fi

gdoc-2-markdown.sh "${GDOC_ID}" "${LAB_DIR}"








