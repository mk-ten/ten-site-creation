#!/bin/bash


DOMAIN=$1
ENV=$2
CDN_AWS_ACCOUNT=$3
CDN_HOSTED_ZONE_ID=$4
SITE_DOMAIN_AWS_ACCOUNT=$5
SITE_HOSTED_ZONE_ID=$6
CLOUDFRONT_DOMAIN=$7
CLOUDFRONT_HOSTED_ZONE_ID=$8

CDN_CFG_TEMPLATE="templates/route53-cdn-cf-alias.template.json"
CDN_CFG_FILE="scratch/route53-cdn-cf-alias.json"

SITE_CFG_TEMPLATE="templates/route53-site-cdn-cname.template.json"
SITE_CFG_FILE="scratch/route53-site-cdn-cname.json"

CDN_SUBDOMAIN=`echo ${DOMAIN}    | sed  's/.com$/.com-cdn/'  | sed  's/\./-/g'`
CDN_FQDN="${CDN_SUBDOMAIN}.${ENV}.tensrv.com"


cd "$(dirname "$0")"
mkdir -p scratch

#echo
#echo ${DOMAIN}
#echo ${CDN_SUBDOMAIN}
#echo ${CDN_FQDN}

echo
echo "Generating DNS Record config for CDN Domain Alias to Cloudfront:  ${CDN_FQDN}  ->  ${CLOUDFRONT_DOMAIN}  ..."
cp -v  ${CDN_CFG_TEMPLATE}  ${CDN_CFG_FILE}
sed -i  "s/\${DOMAIN}/${DOMAIN}/g"  ${CDN_CFG_FILE}
sed -i  "s/\${CDN_FQDN}/${CDN_FQDN}/g"  ${CDN_CFG_FILE}
sed -i  "s/\${CLOUDFRONT_HOSTED_ZONE_ID}/${CLOUDFRONT_HOSTED_ZONE_ID}/g"  ${CDN_CFG_FILE}
sed -i  "s/\${CLOUDFRONT_DOMAIN}/${CLOUDFRONT_DOMAIN}/g"  ${CDN_CFG_FILE}

echo
echo "Creating CDN Domain Alias to Cloudfront  ..."
aws route53  change-resource-record-sets  --hosted-zone-id ${CDN_HOSTED_ZONE_ID}  --change-batch file://${CDN_CFG_FILE}  --profile ${ENV}

echo
echo "Generating DNS Record config for Site Domain CNAME to CDN Domain:  ${DOMAIN}  ->  ${CDN_FQDN}  ..."
cp -v  ${SITE_CFG_TEMPLATE}  ${SITE_CFG_FILE}
sed -i  "s/\${DOMAIN}/${DOMAIN}/g"  ${SITE_CFG_FILE}
sed -i  "s/\${CDN_FQDN}/${CDN_FQDN}/g"  ${SITE_CFG_FILE}

echo
echo "Creating Site Domain CNAME to CDN Domain  ..."
aws route53  change-resource-record-sets  --hosted-zone-id ${SITE_HOSTED_ZONE_ID}  --change-batch file://${SITE_CFG_FILE}  --profile ${ENV}

echo
echo DONE

