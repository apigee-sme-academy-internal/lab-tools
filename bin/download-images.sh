#!/usr/bin/env bash
set -e

function usage() {
  echo "Usage: "
  echo "  $(basename $0) /path/to/source/md/file /path/to/img/dir"
  echo ""
  echo "This script downloads the images from the src attribute in <img /> tags"
  echo "The images are put in the specified image dir."
  echo "The name of the image is computed from the MD5 of the the src attribute"
  echo ""
  echo "e.g."
  echo "  <img src=\"https://foobar\" /> "
  echo "  becomes "
  echo "  80afd4ac300604145c4f4aa7036a5333.png"
  echo ""
  echo ""
}

MD_FILE="$1"
if [ ! -f "${MD_FILE}" ] ; then
  echo "ERROR: MD_FILE is required" && usage && exit 1
fi

IMG_DIR="$2"

if [ ! -d "${IMG_DIR}" ] ; then
  echo "IMG_DIR is required" && usage && exit 1
fi

MD_DIR=$(dirname "${MD_FILE}")
MD_DIR="$(cd "${MD_DIR}" ; pwd)"
MD_FILE=$(basename "${MD_FILE}")

# Download images
pushd "${IMG_DIR}" &> /dev/null
cat  "${MD_DIR}/${MD_FILE}" |
   perl -ne 'm#<img\s+src="(https://[^"]+?)"# && print "$1\n"' |
   sort -u |
   perl -ne 'my $u = $_;
             chomp $u;
             my $h = `md5 -q -s "$u"`;
             chomp $h;
             `curl -sSLo $h.png $u` if ! -f "$h.png"'
popd &> /dev/null