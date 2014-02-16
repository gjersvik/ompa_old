#!/bin/bash
set -u -e;

echo "Get aws utils"
pip -q install awscli

echo "Upload client code."
aws s3 sync ./build s3://ompa.olem.org --quiet --acl public-read

echo "Create a server distrebution."
tar -cvhf ompa.tar bin/

echo "Upload distrebution."
aws s3 cp ompa.tar s3://ompa.olem.org/dist/ompa-$CI_BUILD_NUMBER.tar --acl private

echo "Create Cloude Config".
cloudconfig=$(sed -e "s/BUILD_NUMBER/$CI_BUILD_NUMBER/g" \
-e "s|MONGO_URI|$MONGO_URI|g" <cloud-config.yaml)
echo "$cloudconfig"

echo "Start new server"
instance_id=$(aws ec2 run-instances --image-id ami-480bea3f --security-groups Ompa \
--user-data "$cloudconfig" --instance-type t1.micro --key-name OleMartin \
--iam-instance-profile Name=ompa-server --query 'Instances[*].InstanceId');

echo instance_id=$instance_id

aws ec2 create-tags --resources $instance_id \
--tags Key=Project,Value=ompa Key=BuildId,Value=$CI_BUILD_NUMBER

echo "Update DNS"

echo "Nuke old server"