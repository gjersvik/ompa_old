#!/bin/bash
set -u -e;

echo "Get aws utils"
pip -q install awscli

echo "Upload client code."
aws s3 sync ./build s3://ompa.olem.org --quiet --acl public-read

echo "Create a server distrebution."
mkdir ./ompa
cp -r ./bin ./ompa
zip -r ompa.zip ./ompa Dockerfile Dockerfile.aws.json

echo "Upload distrebution."
aws s3 cp ompa.zip s3://ompa.olem.org/dist/ompa-$CI_BUILD_NUMBER.zip --acl private
