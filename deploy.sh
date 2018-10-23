#!/bin/bash

S3BUCKET='durist-dev-ecs'
STACKNAME='durist-dev-ecs'
GENTEMPLATE="/tmp/${STACKNAME}.json"

# For locally installed aws cli
export PATH="$PATH:${HOME}/.local/bin"

usage () {
    echo "deploy.sh [up|down|status]"
    exit 1
}

case "$1" in
    up)
	aws s3api create-bucket --bucket $S3BUCKET --acl private
	aws cloudformation package --template-file master.yaml --s3-bucket $S3BUCKET --output-template-file $GENTEMPLATE
	aws cloudformation deploy --template-file $GENTEMPLATE --stack-name $STACKNAME --s3-bucket $S3BUCKET --capabilities CAPABILITY_NAMED_IAM
	;;
    down)
	aws cloudformation delete-stack --stack-name $STACKNAME
	aws s3 rb s3://$S3BUCKET --force 
	;;
    status)
	aws cloudformation describe-stack-instance --stack-set-name $STACKNAME
	;;
    *)
	usage
	;;
esac
