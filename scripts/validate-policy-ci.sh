#!/usr/bin/env bash

set -e
set -x

POLICY_FILE=$1

if [ ! -e ${GITHUB_WORKSPACE}/policies/${POLICY_FILE} ]; then
    echo "File ${GITHUB_WORKSPACE}/policies/${POLICY_FILE} not found!"
    exit 1
fi

sudo apt update -y
sudo apt install -y jq
pip install --no-cache-dir cfn-policy-validator
INLINE_POLICY="$(cat ${GITHUB_WORKSPACE}/policies/${POLICY_FILE} | jq --compact-output '.')"
sed -re 's~"PolicyDocument": AutomaticallyReplacedByOurCustomScript~"PolicyDocument": '"$INLINE_POLICY"'~g' "${GITHUB_WORKSPACE}/templates/template.json" > ${GITHUB_WORKSPACE}/templates/template_${POLICY_FILE}
cfn-policy-validator validate --template-path ${GITHUB_WORKSPACE}/templates/template_${POLICY_FILE} --region eu-south-1