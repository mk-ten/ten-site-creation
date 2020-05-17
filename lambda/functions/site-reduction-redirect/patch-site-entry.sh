#!/bin/bash

DOMAIN=$1
SITE_ID=$2
ENV=$3

SCRATCH=scratch
BUILD_OUT="${SCRATCH}/site-reduction-redirect"
REDIRECTS_JSON="site-id-mappings/redirects.${ENV}.json"
REDIRECTS_JSON="${BUILD_OUT}/redirects.json"

cd "$(dirname "$0")"
mkdir -p ${BUILD_OUT}

