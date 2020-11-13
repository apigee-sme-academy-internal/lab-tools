#!/usr/bin/env bash
set -e

function usage() {
  echo "Usage: "
  echo "  $(basename $0) /path/to/file.md"
  echo ""
  echo "This script replaces the value src attribute of the <img /> tags"
  echo "for the MD5 of the URL specified in the src attribute."
  echo ""
  echo "e.g."
  echo "  <img src=\"https://foobar\" /> "
  echo "  becomes"
  echo "  <img src=\"img/80afd4ac300604145c4f4aa7036a5333.png\" />"
  echo ""
}

MD_FILE="$1"
if [ ! -f "${MD_FILE}" ] ; then
  echo -e "ERROR: input file is required\n" && usage && exit 1
fi

# Replace URls
cat  "${MD_FILE}" |
    perl -ne 'if (/(.*<img.+src=")(https:\/\/[^"]+?)(".+)/ ) {
                my $h = `md5 -q -s "$2"`;
                chomp $h;
                print $1."img/".$h.".png".$3."\n"
              } else {
                print $_;
              }'
