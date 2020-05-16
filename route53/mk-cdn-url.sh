#!/bin/bash

SUBDOMAIN=`echo $2    | sed  's/.com$/.com-cdn/'  | sed  's/\./-/g'`

echo ${SUBDOMAIN}
echo ${SUBDOMAIN}.${1}.tensrv.com
