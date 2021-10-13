#!/bin/bash
set -euo pipefail
set -o errexit
set -o errtrace
IFS=$'\n\t'

export S3_ACL=${S3_ACL:-private}
UMASK=${UMASK:-0007}
mkdir -p ${MNT_POINT}

verbose=$(echo $VERBOSE | tr '[:upper:]' '[:lower:]')

export AWSACCESSKEYID=${AWSACCESSKEYID:-$AWS_KEY}
export AWSSECRETACCESSKEY=${AWSSECRETACCESSKEY:-$AWS_SECRET_KEY}
echo "${AWS_KEY}:${AWS_SECRET_KEY}" > /etc/passwd-s3fs
chmod 0400 /etc/passwd-s3fs

if [ "$verbose" == "true" ]; then
  /usr/bin/s3fs  ${S3_BUCKET} ${MNT_POINT} -d -d -f -o passwd_file=/etc/passwd-s3fs -o url=${S3_URL} -o use_path_request_style,allow_other,retries=5 -o umask=${UMASK},uid=${MNT_UID},gid=${MNT_GID}
else
  /usr/bin/s3fs  ${S3_BUCKET} ${MNT_POINT} -f -o passwd_file=/etc/passwd-s3fs -o url=${S3_URL} -o use_path_request_style,allow_other,retries=5 -o umask=${UMASK},uid=${MNT_UID},gid=${MNT_GID}
fi
echo 'started...'
