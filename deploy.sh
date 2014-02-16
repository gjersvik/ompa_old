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

echo "Get id of old server";
old_instance_id=$(aws ec2 describe-instances --output text \
--query 'Reservations[*].Instances[*].InstanceId' \
--filters Name=tag-key,Values=Project Name=tag-value,Values=ompa \
Name=instance-state-name,Values=running)

echo "Start new server"
instance_id=$(aws ec2 run-instances --image-id ami-480bea3f --security-groups Ompa \
--user-data "$cloudconfig" --instance-type t1.micro --key-name OleMartin \
--iam-instance-profile Name=ompa-server --output text \
--query 'Instances[*].InstanceId');

echo instance_id=$instance_id

aws ec2 create-tags --resources $instance_id \
--tags Key=Project,Value=ompa Key=BuildId,Value=$CI_BUILD_NUMBER

echo "Update DNS"
aws ec2 associate-address --instance-id $instance_id --public-ip 79.125.120.89

echo "Nuke old server"
aws ec2 terminate-instances --instance-ids "$old_instance_id"