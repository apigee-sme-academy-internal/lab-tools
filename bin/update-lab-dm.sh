#!/usr/bin/env bash
set -e

export QWIKLABS_REPO_DIR="$1"
export DM_REPO_DIR="$2"
export LAB_PREFIX="$3"
export LAB_REPO_GIT_URL="$4"
export LAB_DEPLOY_KEY_FILE="$5"


function usage() {
  echo "This script updates the DM directory within a Qwiklabs lab"
  echo "Usage:"
  echo "$(basename $0) \\"
  echo "    /path/to/qwiklabs/repo \\"
  echo "    /path/to/dm/repo \\"
  echo "    lab-prefix \\"
  echo "    git@github.com:apigee-sme-academy-internal/lab-repo.git \\"
  echo "    /path/to/deploy/key.pem"
}

# Check arguments
if [ ! -d "${QWIKLABS_REPO_DIR}" ] ; then
  echo "ERROR: QWIKLABS_REPO_DIR is required." && usage ; exit 1;
fi

if [ ! -d "${DM_REPO_DIR}" ] ; then
  echo "ERROR: DM_REPO_DIR is required." && usage ; exit 1;
fi

if [ -z "${LAB_PREFIX}" ] ; then
  echo "ERROR: LAB_PREFIX is required." && usage && exit 1;
fi

if [ -z "${LAB_REPO_GIT_URL}" ] ; then
  echo "ERROR: LAB_REPO_GIT_URL is required." && usage && exit 1;
fi

if [ ! -f "${LAB_DEPLOY_KEY_FILE}" ] ; then
  echo "ERROR: LAB_DEPLOY_KEY_FILE is required." && usage && exit 1;
fi




# Check that lab directory exists
export LAB_DIR=$(find  "${QWIKLABS_REPO_DIR}/labs" -type d -name "${LAB_PREFIX}*" | head -1)
echo ${LAB_DIR}
if [ ! -d "${LAB_DIR}" ]; then
  echo "ERROR: Could not locate lab with prefix ${LAB_PREFIX} in ${QWIKLABS_REPO_DIR}/labs"  && exit 1;
fi


echo "**** Building DM zip for ${LAB_PREFIX} **** "
pushd "${DM_REPO_DIR}" &> /dev/null
./build.sh "${LAB_REPO_GIT_URL}" \
           "master" \
           "${LAB_DEPLOY_KEY_FILE}" \
           "${LAB_PREFIX}.zip"

popd &> /dev/null

export LAB_DM_DIR="${LAB_DIR}/dm"
export LAB_DM_ZIP_FILE="${DM_REPO_DIR}/build/${LAB_PREFIX}.zip"

rm -rf "${LAB_DM_DIR}"
mkdir -p "${LAB_DM_DIR}"

cp "${LAB_DM_ZIP_FILE}"  "${LAB_DM_DIR}"
pushd ${LAB_DM_DIR} &> /dev/null
unzip "${LAB_PREFIX}.zip"
rm -f "${LAB_PREFIX}.zip"
popd &> /dev/null