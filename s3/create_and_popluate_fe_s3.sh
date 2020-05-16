#!/bin/bash

DOMAIN=$1
ENV=$2

SRC_S3_BUCKET=$3

REGION="eu-west-1"
WEBSITE_CFG="artifacts/bucket-websites.cfg.json"
POLICY_TEMPLATE="templates/bucket-policy.template.json"
POLICY_CFG="scratch/bucket-policy.cfg.json"


cd "$(dirname "$0")"
mkdir -p scratch

echo
echo "Creating Bucket for '${DOMAIN}' in '${REGION}'  ..."
aws s3api create-bucket  --bucket ${DOMAIN}  --create-bucket-configuration LocationConstraint=${REGION}  --region ${REGION}  --profile ${ENV}

echo
echo "Enabling Bucket Website  ..."
aws s3api put-bucket-website  --bucket ${DOMAIN}  --website-configuration file://${WEBSITE_CFG}  --profile ${ENV}

echo
echo "Generating Bucket Policy file from template  ..."
cp -v  ${POLICY_TEMPLATE}  ${POLICY_CFG}
sed -i  "s/\${DOMAIN}/${DOMAIN}/g"  ${POLICY_CFG}

echo
echo "Setting Bucket Policy  ..."
aws s3api put-bucket-policy  --bucket ${DOMAIN}  --policy file://${POLICY_CFG}  --profile ${ENV}

echo
echo DONE
