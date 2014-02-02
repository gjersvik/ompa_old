#!/bin/bash
set -u -e;

#Codeship don't have the ofisial aws instaled.
pip install awscli

#Upload client code.
aws s3 sync ./build s3://ompa.olem.org --acl public-read  --delete