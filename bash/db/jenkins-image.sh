#! /usr/bin/env bash
## Multi-account-auto-ecr-image-pusher

EN_NAME=$1
IMAGE_TYPE=$2
REGION=$3
TAG=$4

# Decrypt new assume role credentials before API calls
echo "decrypting AWS credentials..."
mkdir -p $HOME/.aws
gpg --quiet --batch --yes --decrypt \
    --passphrase="$GPG_KEY" \
    --output $HOME/.aws/credentials \
    creds/aws_credentials.gpg

echo "querying account id..."
ACNT_ID=$(aws sts get-caller-identity --query Account --output text --region $REGION --profile #####-${EN_NAME} || exit 1)

if [[ $ACNT_ID == "" ]]; then
    echo -e "\nCRITICAL: No account id found, cannot proceed\n"
    exit 1
else
    echo "\nAccount: ${ACNT_ID}\n"
fi

detect_env () {
    if [[ "$REGION" == "us-east-2" ]]; then
        RG_CODE="oh"  # Ohio
    elif [[ "$REGION" == "us-east-1" ]]; then
        RG_CODE="va" # US East (N. Virginia)
    elif [[ "$REGION" == "us-west-1" ]]; then
        RG_CODE="ca" # N. California
    elif [[ "$REGION" == "us-west-2" ]]; then
        RG_CODE="or" # US West (Oregon)
    elif [[ "$REGION" == "ap-east-1" ]]; then
        RG_CODE="hk" # Hong Kong
    elif [[ "$REGION" == "ap-south-1" ]]; then
        RG_CODE="mb" # Asia Pacific (Mumbai)
    elif [[ "$REGION" == "ap-northeast-3" ]]; then
        RG_CODE="os" # Osaka-Local
    elif [[ "$REGION" == "ap-northeast-2" ]]; then
        RG_CODE="se" # Asia Pacific (Seoul)
    elif [[ "$REGION" == "ap-southeast-1" ]]; then
        RG_CODE="sg" # Singapore
    elif [[ "$REGION" == "ap-southeast-2" ]]; then
        RG_CODE="sd" # Asia Pacific (Sydney) 
    elif [[ "$REGION" == "ap-northeast-1" ]]; then
        RG_CODE="tk" # Tokyo 
    elif [[ "$REGION" == "ca-central-1" ]]; then
        RG_CODE="cn" # Canada (Central)
    elif [[ "$REGION" == "eu-central-1" ]]; then
        RG_CODE="ff" # Frankfurt
    elif [[ "$REGION" == "eu-west-1" ]]; then
        RG_CODE="ie" # Europe (Ireland)
    elif [[ "$REGION" == "eu-west-2" ]]; then
        RG_CODE="ld" # London
    elif [[ "$REGION" == "eu-west-3" ]]; then
        RG_CODE="pr" # Europe (Paris) 
    elif [[ "$REGION" == "eu-north-1" ]]; then
        RG_CODE="st" # Stockholm
    elif [[ "$REGION" == "me-south-1" ]]; then
        RG_CODE="bh" # Middle East (Bahrain)
    elif [[ "$REGION" == "sa-east-1" ]]; then
        RG_CODE="sp" # São Paulo 
    else
        echo "Unknown Region" && exit 1
    fi
}

# Function Call
detect_env

# Docker Image Creation
echo "AWS VERSION" && aws --version
echo "fetching and pushing jenkins image to ECR..."
docker login -u AWS -p $(aws ecr get-login-password --profile #####-${EN_NAME} --region ${REGION}) $ACNT_ID.dkr.ecr.${REGION}.amazonaws.com
cd eks-jenkins/dockerfile/${IMAGE_TYPE}/
docker build -t jenkins-${IMAGE_TYPE} .
docker tag jenkins-${IMAGE_TYPE}:latest ${ACNT_ID}.dkr.ecr.${REGION}.amazonaws.com/#####-${EN_NAME}-${RG_CODE}-jenkins-${IMAGE_TYPE}:${TAG}
docker push ${ACNT_ID}.dkr.ecr.${REGION}.amazonaws.com/#####-${EN_NAME}-${RG_CODE}-jenkins-${IMAGE_TYPE}:${TAG}
