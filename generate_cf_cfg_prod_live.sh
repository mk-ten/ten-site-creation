#!/bin/bash

CLIENT_DOMAIN_OR_SLUG=$1

# These would need to be injected in the future
LAMBDA_FN_VER_MOVE_HOST=1
LAMBDA_FN_VER_SITE_REDUCTION=17

AWS_ACCOUNT=171408413795
S3_ORIGIN_ACCESS_ID_CODE=EDJJ5HN3B7LFY
CERT_ARN_CODE="5df35dfb-238e-44d7-a673-15f9c1c90e8d"
WEB_ACL_ID="e4e08c0f-31a0-4bdf-a5f9-e046289d7f1b"

ENV=production
S3_ORIGIN_ACCESS_ID="origin-access-identity\/cloudfront\/${S3_ORIGIN_ACCESS_ID_CODE}"
LAMBDA_FN_ARN_MOVE_HOST="arn:aws:lambda:us-east-1:${AWS_ACCOUNT}:function:move-host-header:${LAMBDA_FN_VER_MOVE_HOST}"
LAMBDA_FN_ARN_SITE_REDUCTION="arn:aws:lambda:us-east-1:${AWS_ACCOUNT}:function:site-reduction-redirect:${LAMBDA_FN_VER_SITE_REDUCTION}"
CERT_ARN="arn:aws:acm:us-east-1:${AWS_ACCOUNT}:certificate\/${CERT_ARN_CODE}"


./generate_cf_cfg.sh  1  $CLIENT_DOMAIN_OR_SLUG  $ENV  $S3_ORIGIN_ACCESS_ID  $LAMBDA_FN_ARN_MOVE_HOST  $LAMBDA_FN_ARN_SITE_REDUCTION  $CERT_ARN  $WEB_ACL_ID


