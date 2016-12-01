#!/bin/bash

#################
# CONFIGURATION #
#################
KUBECTL_VERSION=v1.4.6
HELM_VERSION=v2.0.0
DELETE=true
BUILD=true
PUSH=true
ATTACH=true
#################

PROJECT=$(gcloud config list project --format="value(core.project)" 2> /dev/null)
WD=$(pwd)

# Build the docker image
if $BUILD; then
  
  # Download the kubectl binary to work with the cluster
  if [ -f "$WD/kubectl" ]; then 
    echo "Skipping kubectl download..."
  else
    echo "Downloading kubectl, this may take a while, the file is ~65 MB..."
    curl -O https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl
    chmod +x ./kubectl > /dev/null 2>&1 
  fi

  # Download the helm version to work with the cluster
  if [ -f "$WD/helm" ]; then
    echo "Skipping helm download..."
  else
    echo "Downloading helm, this may take a while, the file is ~13 MB..."
    wget https://kubernetes-helm.storage.googleapis.com/helm-$HELM_VERSION-linux-amd64.tar.gz
    tar -zxvf helm-$HELM_VERSION-linux-amd64.tar.gz > /dev/null 2>&1 
    cp ./linux-amd64/helm ./helm
    rm -rf ./linux-amd64/
  fi
  
  # Build the docker image
  echo "Building docker tag => gcr.io/$PROJECT/helm:latest"
  docker build -t gcr.io/$PROJECT/helm:latest .
  
  # Clean up workspace
  if $DELETE; then
    rm kubectl helm
  else
    echo "Leaving kubectl and helm cli locally..."
  fi
else
  echo "Skipping build..."
fi

# Push the image to gcloud
if $PUSH; then
  echo "Pushing image gcr.io/$PROJECT/helm:latest to google cloud..."
  gcloud docker push gcr.io/$PROJECT/helm:latest
else
  echo "Skipping gcloud docker push..."
fi 

# Output the command to run the container with a shell session or run shell session
if $ATTACH; then
  echo "spinning up a helm-pod..."
  kubectl run -i -t helm --image=gcr.io/$PROJECT/helm:latest --rm=true
else
  echo ""
  echo ""
  echo "USAGE:"
  echo "  kubectl run -i -t helm --image=gcr.io/$PROJECT/helm:latest --rm=true" 
  echo ""  
fi
