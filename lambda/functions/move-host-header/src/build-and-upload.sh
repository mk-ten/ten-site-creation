#!/bin/bash

set -e
set -o pipefail


if [ -z "$1" ]; then
    echo "Environment is unset or set to the empty string, exiting"
    exit 1
fi
ENV=$1

if [ $ENV == "prod-use1" ]; then
    PROFILE="production"
    BUCKET_NAME="tenproduct-use1-prod-lambda-edge-functions"
elif [ $ENV == "staging-use1" ]; then
    PROFILE="staging"
    BUCKET_NAME="tenproduct-use1-staging-lambda-edge-functions"
elif [ $ENV == "qa-use1" ]; then
    PROFILE="qa"
    BUCKET_NAME="tenproduct-use1-qa-lambda-edge-functions"
elif [ $ENV == "sandbox-use1" ]; then
    PROFILE="sandbox"
    BUCKET_NAME="tenproduct-use1-sandbox-lambda-edge-functions"
else
    echo "Wrong environment. Expected: prod-use1, staging-use1, qa-use1 or sandbox-use1."
    exit 1
fi

OUTPUT_FILENAME="move-host-header-$(date '+%Y%m%d-%H%M%S').zip"
rm -f move-host-header-*.zip

zip -r $OUTPUT_FILENAME *

read -p "Do you want to upload the new lambda function version to $BUCKET_NAME bucket? [y/N] " -n 1 -r
if [[ $REPLY =~ [Yy]$ ]]; then
    echo ""
    aws --profile $PROFILE s3 cp $OUTPUT_FILENAME s3://$BUCKET_NAME/move-host-header/move-host-header.zip --region us-east-1
    echo ""
    echo "Updating lambda function code with the new version from the S3 bucket https://s3.amazonaws.com/$BUCKET_NAME/move-host-header/move-host-header.zip"
    aws --profile $PROFILE \
        lambda update-function-code \
            --function-name move-host-header \
            --s3-bucket $BUCKET_NAME \
            --s3-key move-host-header/move-host-header.zip \
            --region us-east-1 \
            --publish
    echo "Everything is done."
fi
echo ""
