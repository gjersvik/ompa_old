#!/bin/bash
set -u -e;

echo "Get aws utils"
pip -q install awscli

echo "Upload client code."
aws s3 sync ./build/web s3://ompa.olem.org --quiet --acl public-read

echo "Create a server distrebution."
mkdir ./ompa
cp -r ./build/bin/* ./ompa
zip -r ompa.zip ./ompa Dockerfile Dockerrun.aws.json

echo "Upload distrebution."
aws s3 cp ompa.zip s3://ompa.olem.org/dist/ompa-$CI_BUILD_NUMBER.zip --acl private

echo "Add application version"
aws elasticbeanstalk create-application-version --application-name ompa --version-label $CI_BUILD_NUMBER  --source-bundle S3Bucket=ompa.olem.org,S3Key=dist/ompa-$CI_BUILD_NUMBER.zip

echo "Run in environment."
aws elasticbeanstalk update-environment --environment-name ompa-env --version-label $CI_BUILD_NUMBER