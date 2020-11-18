#!/bin/bash

set -o pipefail
set -e

DATE=$(echo `date`)
REGION=eu-west-2
TG_ARN=arn:aws:elasticloadbalancing:eu-west-2:948686707161:targetgroup/core-sudjsoc-tg/78032aef615eb413


instance_id(){
	echo "Getting instance id"
	instance_id=$(curl http://169.254.169.254/1.0/meta-data/instance-id)
	echo "instance id: ${instance_id}"
}

private_ip(){
	echo "Finding public ip"
	public_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
	echo "Public ip: ${public_ip}"
}


tg_arn(){
	echo "Finding load balancer"
	lb_output=$(aws elbv2 describe-target-groups --target-group-arns ${TG_ARN} --output text | awk '{print $2}' | grep 'arn')
	echo ${lb_output}
}

assign_instance_to_lb(){
	echo "Registering instance to target group: ${TG_ARN}"
	assignment_output=$(aws elbv2 register-targets --target-group-arn ${TG_ARN} --targets Id=${public_ip})
}


main(){
	instance_id
	private_ip
	target_arn
	assign_instance_to_lb
}

main
