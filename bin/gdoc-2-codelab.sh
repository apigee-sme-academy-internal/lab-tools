#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

usage() {
  echo "Usage: "
  echo "  $(basename $0): gdoc-id /path/to/codelab/dir"
}

export GDOC_ID="$1"
export CODELAB_DIR="$2"

export CLAAT=$DIR/claat.$(uname -s)

if [ ! -f "${CLAAT}" ] ; then
  echo "ERROR: No claat tool found for your Operating System ($(uname -s)"
fi


if [ -z "${GDOC_ID}" ] ; then
  echo "ERROR: Google Doc ID is required" && usage && exit 1;
fi

if [ ! -d "${CODELAB_DIR}" ] ; then
    #echo "ERROR: CODELAB directory is required" && usage && exit 1;
    mkdir -p "${CODELAB_DIR}"
fi

TEMP_DIR=$(mktemp -d -t claat-codelab)

pushd "${TEMP_DIR}" &> /dev/null
$CLAAT export -f html "${GDOC_ID}"
export CONVERTED_LAB_DIR="$(pwd)/$(ls -1 | head -1)"
popd &> /dev/null

if [ ! -d "${CODELAB_DIR}/instructions" ] ; then
  mkdir -p "${CODELAB_DIR}/instructions"
  mkdir -p "${CODELAB_DIR}/instructions/img"
fi

# Replace MD file
rm -rf "${CODELAB_DIR}/instructions/index.html"
cp "${CONVERTED_LAB_DIR}/index.html" "${CODELAB_DIR}/instructions/index.html"

# Fix bold tags
perl -0777 -i.original -pe 's#\*\*(.+?)\*\*#<b>\1</b>#g' "${CODELAB_DIR}/instructions/index.html"

rm -f "${CODELAB_DIR}/instructions/index.html.original"

"${DIR}/download-codelab-images.sh" "${CODELAB_DIR}/instructions/index.html" "${CONVERTED_LAB_DIR}/img"
"${DIR}/replace-codelab-images.sh" "${CODELAB_DIR}/instructions/index.html" > "${CODELAB_DIR}/instructions/index.html.temp"
mv "${CODELAB_DIR}/instructions/index.html.temp" "${CODELAB_DIR}/instructions/index.html"

# Replace images
rm -rf "${CODELAB_DIR}/instructions/img"
cp -R "${CONVERTED_LAB_DIR}/img" "${CODELAB_DIR}/instructions"

#Copy metadata JSON file
cp -R "${CONVERTED_LAB_DIR}/codelab.json" "${CODELAB_DIR}/instructions/codelab.json"

# Cleanup temp dir
rm -rf "${TEMP_DIR}"
