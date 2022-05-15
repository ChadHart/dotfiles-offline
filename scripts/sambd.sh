#!/bin/bash
branch=`git branch --show-current`
devLayerArn=`aws lambda list-layer-versions --layer-name CoreLayer-dev --max-items 1 | jq '.LayerVersions[0] .LayerVersionArn'`
prodLayerArn=`aws lambda list-layer-versions --layer-name CoreLayer-prod --max-items 1 | jq '.LayerVersions[0] .LayerVersionArn'`


if [ "$branch" == "main" ]
then
  echo "Are you sure you want to deploy to Prod?"
  read ans

  if [ "$ans" == "yes" ]
  then
    sam build && sam deploy --config-env prod --parameter-overrides CoreLayerArn="$prodLayerArn"
  else
    echo "Hey, thanks for comin out..."
  fi

elif [ "$branch" == "dev" ]
then
  sam build && sam deploy --parameter-overrides CoreLayerArn="$devLayerArn"
  
fi

