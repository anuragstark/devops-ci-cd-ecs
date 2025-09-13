#!/bin/bash

# Deploy script for AWS ECS
set -e

# Configuration
CLUSTER_NAME="devops-cluster"
SERVICE_NAME="devops-service"
REGION="us-east-1"

echo "Starting deployment to AWS ECS..."

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check AWS credentials
if ! aws sts get-caller-identity &> /dev/null; then
    echo "AWS credentials not configured. Please configure them first."
    exit 1
fi

# Update ECS service
echo "Updating ECS service: $SERVICE_NAME in cluster: $CLUSTER_NAME"
aws ecs update-service \
    --cluster $CLUSTER_NAME \
    --service $SERVICE_NAME \
    --force-new-deployment \
    --region $REGION

# Wait for deployment to complete
echo "Waiting for deployment to complete..."
aws ecs wait services-stable \
    --cluster $CLUSTER_NAME \
    --services $SERVICE_NAME \
    --region $REGION

echo "Deployment completed successfully!"

# Get service URL
LOAD_BALANCER=$(aws elbv2 describe-load-balancers --names devops-alb --region $REGION --query 'LoadBalancers[0].DNSName' --output text)
echo "Application is available at: http://$LOAD_BALANCER"