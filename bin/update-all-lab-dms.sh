#!/usr/bin/env bash
set -e

export QWIKLABS_REPO_DIR="$1"
export DM_REPO_DIR="$2"


usage() {
  echo "$(basename "$0") /path/to/qwiklabs/repo /path/to/labs/dm"
}

# Check arguments
if [ ! -d "${QWIKLABS_REPO_DIR}" ] ; then
  echo "ERROR: QWIKLABS_REPO_DIR is required." && usage ; exit 1;
fi


if [ ! -d "${DM_REPO_DIR}" ] ; then
  echo "ERROR: DM_REPO_DIR is required." && usage ; exit 1;
fi

DEPLOY_KEY_FILE=$(mktemp)

function fetch_deploy_key() {
  gcloud config set project apigee-sme-academy
  gcloud secrets versions access --secret=automation-deploy-key latest > "${DEPLOY_KEY_FILE}"
}

function clean_deploy_key() {
  rm -f "${DEPLOY_KEY_FILE}"
}


trap clean_deploy_key EXIT
fetch_deploy_key


export LAB_PREFIX="enbl007"
export LAB_REPO="git@github.com:apigee-sme-academy-internal/app-modernization-lab-1.git"
update-lab-dm.sh  "${QWIKLABS_REPO_DIR}" "${DM_REPO_DIR}" "${LAB_PREFIX}" "${LAB_REPO}" "${DEPLOY_KEY_FILE}"

export LAB_PREFIX="enbl008"
export LAB_REPO="git@github.com:apigee-sme-academy-internal/app-modernization-lab-2.git"
update-lab-dm.sh  "${QWIKLABS_REPO_DIR}" "${DM_REPO_DIR}" "${LAB_PREFIX}" "${LAB_REPO}" "${DEPLOY_KEY_FILE}"

export LAB_PREFIX="enbl009"
export LAB_REPO="git@github.com:apigee-sme-academy-internal/app-modernization-lab-3.git"
update-lab-dm.sh  "${QWIKLABS_REPO_DIR}" "${DM_REPO_DIR}" "${LAB_PREFIX}" "${LAB_REPO}" "${DEPLOY_KEY_FILE}"

export LAB_PREFIX="enbl010"
export LAB_REPO="git@github.com:apigee-sme-academy-internal/app-modernization-lab-4.git"
update-lab-dm.sh  "${QWIKLABS_REPO_DIR}" "${DM_REPO_DIR}" "${LAB_PREFIX}" "${LAB_REPO}" "${DEPLOY_KEY_FILE}"

export LAB_PREFIX="enbl011"
export LAB_REPO="git@github.com:apigee-sme-academy-internal/app-modernization-lab-5.git"
update-lab-dm.sh  "${QWIKLABS_REPO_DIR}" "${DM_REPO_DIR}" "${LAB_PREFIX}" "${LAB_REPO}" "${DEPLOY_KEY_FILE}"

export LAB_PREFIX="enbl012"
export LAB_REPO="git@github.com:apigee-sme-academy-internal/app-modernization-lab-6.git"
update-lab-dm.sh  "${QWIKLABS_REPO_DIR}" "${DM_REPO_DIR}" "${LAB_PREFIX}" "${LAB_REPO}" "${DEPLOY_KEY_FILE}"