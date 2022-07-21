#!/usr/bin/env bash

set -e
set -x


INLINE_POLICY="$(cat /policies/policy.json | jq --compact-output '.')"
sed -re 's~"PolicyDocument": AutomaticallyReplacedByOurCustomScript~"PolicyDocument": '"$INLINE_POLICY"'~g' "/templates/template.json" > /templates/template_policy.json

cfn-policy-validator validate --template-path /templates/template_policy.json --region eu-south-1
