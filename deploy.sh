#!/bin/bash
set -u -e;

echo "Get aws utils"
pip -q install awscli

echo "Upload client code."
aws s3 sync ./build s3://ompa.olem.org --quiet --acl public-read

echo "Create a server distrebution."
mkdir ompa
dart --snapshot=ompa/ompa.snapshot bin/ompa.dart
cp bin/start.sh ompa/start.sh
tar -cvf ompa.tar ompa/

echo "Upload distrebution."
aws s3 cp ompa.tar s3://ompa.olem.org/dist/ompa-$CI_BUILD_NUMBER.tar --acl private

echo "Create Cloude Config".
cloudconfig=$(sed -e "s/BUILD_NUMBER/$CI_BUILD_NUMBER/g" \
-e "s|MONGO_URI|$MONGO_URI|g" <cloud-config.yaml)
echo "$cloudconfig"

echo "Start new server"
aws iam create-instance-profile --instance-profile-name ompa-$CI_BUILD_NUMBER
aws iam add-role-to-instance-profile \
--instance-profile-name ompa-$CI_BUILD_NUMBER --role-name ompa-server

aws ec2 run-instances --image-id ami-0e0cf879 --security-groups Ompa \
--user-data "$cloudconfig" --instance-type t1.micro --key-name OleMartin \
--iam-instance-profile Name="ompa-$CI_BUILD_NUMBER"

echo "Wait for server"

echo "Update DNS"

echo "Nuke old server"