#!/bin/bash
set -e

S3_BUCKET="www.veewee.org"

################################################################################
# Upload S3
################################################################################
echo "Uploading new assets to s3 bucket $S3_BUCKET"
echo "[default]" > ~/.s3cfg
echo "access_key=$S3_ACCESS_KEY" >> ~/.s3cfg
echo "secret_key=$S3_SECRET_KEY" >> ~/.s3cfg

s3cmd_version=1.5.0-rc1
echo "download s3cmd $s3cmd_version"
curl -O -L https://github.com/s3tools/s3cmd/archive/v$s3cmd_version.tar.gz
tar xzf v$s3cmd_version.tar.gz

echo "upload js files"
s3cmd-$s3cmd_version/s3cmd sync  --acl-public --progress --mime-type="application/javascript" ./ s3://$S3_BUCKET --bucket-location=EU --exclude '*' --include '*.js' --exclude 'scripts-ci/*' --exclude 'vendor/*'
echo "uploading css"
s3cmd-$s3cmd_version/s3cmd sync  --acl-public --progress --mime-type="text/css" ./ s3://$S3_BUCKET --bucket-location=EU --exclude '*' --include '*.css' --exclude 'scripts-ci/*' --exclude 'vendor/*'
echo "uploading html"
s3cmd-$s3cmd_version/s3cmd sync  --acl-public --progress --mime-type="text/html" ./ s3://$S3_BUCKET --bucket-location=EU --exclude '*' --include '*.html' --exclude 'scripts-ci/*' --exclude 'vendor/*'
echo "uploading all the rest"
s3cmd-$s3cmd_version/s3cmd sync  --acl-public -M --progress ./ s3://$S3_BUCKET --bucket-location=EU --exclude '*.css' --exclude '*.js' --exclude '*.html' --exclude 'scripts-ci/*' --exclude 'vendor/*'
