#!/bin/bash

branch=`git branch --show-current`
devLayerArn=`aws lambda list-layer-versions --layer-name CoreLayer-dev --max-items 1 | jq '.LayerVersions[0] .LayerVersionArn'`
prodLayerArn=`aws lambda list-layer-versions --layer-name CoreLayer-prod --max-items 1 | jq '.LayerVersions[0] .LayerVersionArn'`

if [[ "$PWD" == *"zip-functions"* ]]
then
  stackName="CoreAuto"
elif [[ "$PWD" == *"BCBS-Renewals-Zip"* ]]
then
  stackName="Renewals-Zip"
fi


if [ "$branch" == "main" ]
then

  echo "Are you sure you want to deploy to Prod?"

  if [ "$ans" == "yes" ]
  then
    sam sync --config-env prod --parameter-overrides CoreLayerArn="$prodLayerArn" --stack-name "$stackName"-prod --watch
  else
    echo "Hey, thanks for comin out..."
  fi

elif [ "$branch" == "dev" ]
then
  sam sync --parameter-overrides CoreLayerArn="$devLayerArn" --stack-name "$stackName"-dev --watch
fi

