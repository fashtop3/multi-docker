#!/usr/bin/env bash
# install AWS SDK
# https://haoliangyu.github.io/blog/2018/03/19/AWS-ECS-auto-deployment-with-Travis-CI/
pip install --user awscli
export PATH=$PATH:$HOME/.local/bin

# install necessary dependency for ecs-deploy
add-apt-repository ppa:eugenesan/ppa
apt-get update
apt-get install jq -y

# install ecs-deploy
curl https://raw.githubusercontent.com/silinternational/ecs-deploy/master/ecs-deploy | \
  sudo tee -a /usr/bin/ecs-deploy
sudo chmod +x /usr/bin/ecs-deploy

# login AWS ECR
eval $(aws ecr get-login --region eu-central-1 --no-include-email)

# or login DockerHub
# docker login --username $DOCKER_HUB_USER --password $DOCKER_HUB_PSW

# build the docker image and push to an image repository
docker build -t 686233958969.dkr.ecr.eu-central-1.amazonaws.com/multi-client ./client
docker push 686233958969.dkr.ecr.eu-central-1.amazonaws.com/multi-client

# update an AWS ECS service with the new image
#ecs-deploy -c $CLUSTER_NAME -n $SERVICE_NAME -i $IMAGE_REPO_URL:latest
