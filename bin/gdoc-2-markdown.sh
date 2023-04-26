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
    #echo "ERROR: QWIKLAB directory is required" && usage && exit 1;
    mkdir -p "${QWIKLAB_DIR}"
fi

TEMP_DIR=$(mktemp -d -t claat-qwiklab)

pushd "${TEMP_DIR}" &> /dev/null
$CLAAT export -f md "${GDOC_ID}"
if [ ! -f codelab.json ] ; then
  cd * # switch into the lab directory
fi
export CONVERTED_LAB_DIR="$(pwd)"
popd &> /dev/null

if [ ! -d "${QWIKLAB_DIR}/instructions" ] ; then
  mkdir -p "${QWIKLAB_DIR}/instructions"
  mkdir -p "${QWIKLAB_DIR}/instructions/img"
fi

# Replace MD file
rm -rf "${QWIKLAB_DIR}/instructions/en.md"
cp "${CONVERTED_LAB_DIR}/index.md" "${QWIKLAB_DIR}/instructions/en.md"

# Post-process MD file
# Syntax highlighting
perl -0777 -i.original -pe 's/```\s+!lang\s+/```/igs' "${QWIKLAB_DIR}/instructions/en.md"

# MD pass-through
perl -0777 -i.original -pe 's/```\s*!md-start//igs' "${QWIKLAB_DIR}/instructions/en.md"
perl -0777 -i.original -pe 's/!md-end\s*```//igs' "${QWIKLAB_DIR}/instructions/en.md"

# Fix bold tags
perl -0777 -i.original -pe 's#\*\*(.+?)\*\*#<b>\1</b>#g' "${QWIKLAB_DIR}/instructions/en.md"

# Remove metadata
perl -0777 -i.original -pe 's#---.+?---##is' "${QWIKLAB_DIR}/instructions/en.md"

# Remove feedback link
perl -0777 -i.original -pe 's#\[\s*codelab\s*feedback\s*]\(.+?\)##is' "${QWIKLAB_DIR}/instructions/en.md"

# fix warning boxes
perl -0777 -i.original -pe 's/^> aside negative((?:\R^>.*)*)/<div><ql-warningbox>\1\n<\/ql-warningbox><\/div>/gm' "${QWIKLAB_DIR}/instructions/en.md"
perl -i.original -pe 's/^> // if (/^<div><ql-warningbox>/../^<\/ql-warningbox><\/div>/);' "${QWIKLAB_DIR}/instructions/en.md"

# fix info boxes
perl -0777 -i.original -pe 's/^> aside positive((?:\R^>.*)*)/<div><ql-infobox>\1\n<\/ql-infobox><\/div>/gm' "${QWIKLAB_DIR}/instructions/en.md"
perl -i.original -pe 's/^> // if (/^<div><ql-infobox>/../^<\/ql-infobox><\/div>/);' "${QWIKLAB_DIR}/instructions/en.md"

rm -f "${QWIKLAB_DIR}/instructions/en.md.original"

"${DIR}/download-markdown-images.sh" "${QWIKLAB_DIR}/instructions/en.md" "${CONVERTED_LAB_DIR}/img"
"${DIR}/replace-markdown-images.sh" "${QWIKLAB_DIR}/instructions/en.md" > "${QWIKLAB_DIR}/instructions/en.md.temp"
mv "${QWIKLAB_DIR}/instructions/en.md.temp" "${QWIKLAB_DIR}/instructions/en.md"

# Replace images
rm -rf "${QWIKLAB_DIR}/instructions/img"
cp -R "${CONVERTED_LAB_DIR}/img" "${QWIKLAB_DIR}/instructions"

# Cleanup temp dir
rm -rf "${TEMP_DIR}"
