#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

usage() {
  echo "Usage: "
  echo "  $(basename $0): gdoc-id /path/to/qwiklab/dir"
}

export GDOC_ID="$1"
export QWIKLAB_DIR="$2"

export CLAAT=$DIR/claat.$(uname -s)

if [ ! -f "${CLAAT}" ] ; then
  echo "ERROR: No claat tool found for your Operating System ($(uname -s)"
fi


if [ -z "${GDOC_ID}" ] ; then
  echo "ERROR: Google Doc ID is required" && usage && exit 1;
fi

if [ ! -d "${QWIKLAB_DIR}" ] ; then
    echo "ERROR: QWIKLAB directory is required" && usage && exit 1;
fi

TEMP_DIR=$(mktemp -d -t claat-qwiklab)

pushd "${TEMP_DIR}" &> /dev/null
$CLAAT export -f md "${GDOC_ID}"
export CONVERTED_LAB_DIR="$(pwd)/$(ls -1 | head -1)"
popd &> /dev/null

# Replace MD file
rm -rf "${QWIKLAB_DIR}/instructions/en.md"
cp "${CONVERTED_LAB_DIR}/index.md" "${QWIKLAB_DIR}/instructions/en.md"

# Post-process MD file
# Syntax highlighting
perl -0777 -i.original -pe 's/```\s+!lang\s+/```/igs' "${QWIKLAB_DIR}/instructions/en.md"

# MD pass-through
perl -0777 -i.original -pe 's/```\s*!md-start//igs' "${QWIKLAB_DIR}/instructions/en.md"
perl -0777 -i.original -pe 's/!md-end\s*```//igs' "${QWIKLAB_DIR}/instructions/en.md"

rm -f "${QWIKLAB_DIR}/instructions/en.md.original"

# Replace images
rm -rf "${QWIKLAB_DIR}/instructions/img"
cp -R "${CONVERTED_LAB_DIR}/img" "${QWIKLAB_DIR}/instructions"

# Cleanup temp dir
rm -rf "${TEMP_DIR}"