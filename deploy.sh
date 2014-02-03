#!/bin/bash
set -u -e;

#Get aws utils
pip -q install awscli

#Upload client code.
aws s3 sync ./build s3://ompa.olem.org --acl public-read

#Create a distrebution
mkdir ompa
dart --snapshot=ompa/ompa.snapshot bin/ompa.dart
cp bin/start.sh ompa/start.sh
tar -cvf ompa.tar ompa/

#Upload distrebution.
aws s3 cp ompa.tar s3://ompa.olem.org/dist/ompa-$CI_BUILD_NUMBER.tar --acl private

#Create Cloude Config

#Start new server

#Wait for server

#Update DNS



#Nuke old server