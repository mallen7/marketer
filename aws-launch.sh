#!/bin/bash

# Variables
AMI_ID="ami-0230bd60aa48260c6" # Replace with your preferred AMI ID
INSTANCE_TYPE="t3.xlarge" # Replace with your desired instance type
KEY_NAME="sallen-aws" # Replace with your EC2 key pair name
SECURITY_GROUP="sg-09944460e59f79976" # Replace with your security group ID
REPO_URL="https://github.com/mscottallen/marketer.git" # Replace with your repository URL

# Launch EC2 instance
INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "${AMI_ID}" \
    --instance-type "${INSTANCE_TYPE}" \
    --key-name "${KEY_NAME}" \
    --security-group-ids "${SECURITY_GROUP}" \
    --query 'Instances[0].InstanceId' \
    --output text)

echo "Instance ${INSTANCE_ID} is launching..."

# Wait for the instance to be in a running state
aws ec2 wait instance-running --instance-ids "${INSTANCE_ID}"

# Get the public IP address of the instance
PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "${INSTANCE_ID}" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text)

echo "Instance is up and running at IP address ${PUBLIC_IP}"

# SSH and Clone Repo
# Note: This assumes you have SSH access set up for the EC2 instance.
ssh -o "StrictHostKeyChecking=no" -i /Users/sallen/.ssh/sallen-aws.pem ec2-user@"${PUBLIC_IP}" << "EOF"
sudo mkdir /opt
sudo chown ec2-user:ec2-user /opt
git clone ${REPO_URL} /opt
EOF

echo "Repository cloned to /opt/repo on instance"

# Provide instructions to user
echo "To access your instance, use: ssh -i /Users/sallen/.ssh/sallen-aws.pem ec2-user@${PUBLIC_IP}"
echo "To terminate the instance, use: aws ec2 terminate-instances --instance-ids ${INSTANCE_ID}"

aws ec2 terminate-instances --instance-ids "${INSTANCE_ID}"
echo "Instance ${INSTANCE_ID} is terminating..."