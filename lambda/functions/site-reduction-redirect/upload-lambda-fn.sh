#!/bin/bash

DOMAIN=$1
SITE_ID=$2
ENV=$3

FN_NAME=site-reduction-redirect
SCRATCH=scratch
BUILD_OUT="${SCRATCH}/${FN_NAME}"
REDIRECTS_JSON_SRC="site-id-mappings/redirects.${ENV}.json"
REDIRECTS_JSON="${BUILD_OUT}/redirects.json"

cd "$(dirname "$0")"
mkdir -p ${BUILD_OUT}

cp -Rv  src/*  ${BUILD_OUT}/
cp -v  ${REDIRECTS_JSON_SRC}  ${REDIRECTS_JSON}

cd  ${SCRATCH}
zip -r  ${FN_NAME}.zip  ${FN_NAME}
