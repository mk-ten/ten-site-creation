#!/bin/bash

IS_PROD=$1
CLIENT_DOMAIN_SLUG=$2
ENV=$3
S3_ORIGIN_ACCESS_ID=$4
LAMBDA_FN_ARN_MOVE_HOST=$5
LAMBDA_FN_ARN_SITE_REDUCTION=$6
CERT_ARN=$7
WEB_ACL_ID=$8


if  [ "$IS_PROD" == "1" ]
then
	DOMAIN=${CLIENT_DOMAIN_SLUG}
	DOMAIN_HYPHENATED="${CLIENT_DOMAIN_SLUG//./-}"
else
	DOMAIN="tp-${ENV}-${CLIENT_DOMAIN_SLUG}.tenproduct.com"
	DOMAIN_HYPHENATED="tp-${ENV}-${CLIENT_DOMAIN_SLUG}-tenproduct-com"
fi

DATE=`date +"%Y%m%d"`
TIME=`date +"%H%M%S"`
CFDIST_CREATION_CALLER_REF="${DATE}T${TIME}"

TEMPLATE_FILE=./templates/cloudfront-site-cfg.template.json
CFG_FILE=./cloudfront-site-cfg--${CLIENT_DOMAIN_SLUG}--${ENV}.json

cp -v  $TEMPLATE_FILE  $CFG_FILE


#CFDIST_CREATION_CALLER_REF
#ENV
#DOMAIN
#DOMAIN_HYPHENATED
#S3_ORIGIN_ACCESS_ID
#LAMBDA_FN_ARN_MOVE_HOST
#LAMBDA_FN_ARN_SITE_REDUCTION
#CERT_ARN
#WEB_ACL_ID



function _sed {
	echo "  Running sed $1 ..."
	sed -i  $1  $CFG_FILE
}

_sed  "s/\${CFDIST_CREATION_CALLER_REF}/$CFDIST_CREATION_CALLER_REF/g"
_sed  "s/\${ENV}/$ENV/g"
_sed  "s/\${DOMAIN}/$DOMAIN/g"
_sed  "s/\${DOMAIN_HYPHENATED}/$DOMAIN_HYPHENATED/g"
_sed  "s/\${S3_ORIGIN_ACCESS_ID}/$S3_ORIGIN_ACCESS_ID/g"
_sed  "s/\${LAMBDA_FN_ARN_MOVE_HOST}/$LAMBDA_FN_ARN_MOVE_HOST/g"
_sed  "s/\${LAMBDA_FN_ARN_SITE_REDUCTION}/$LAMBDA_FN_ARN_SITE_REDUCTION/g"
_sed  "s/\${CERT_ARN}/$CERT_ARN/g"
_sed  "s/\${WEB_ACL_ID}/$WEB_ACL_ID/g"

# Rename the logs bucket reference
_sed  "s/tenplatform-euw1-production-logs/tenplatform-euw1-prod-logs/g"


