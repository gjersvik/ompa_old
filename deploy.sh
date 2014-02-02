#!/bin/bash
set -u -e;

#Upload client code.
aws s3 sync ./build s3://ompa.olem.org --acl public-read  --delete