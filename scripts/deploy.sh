#!/bin/sh

if [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
  fastlane beta

elif [[ "$TRAVIS_BRANCH" == "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
    git config --global user.email $GH_EMAIL
    git config --global user.name "Flyve MDM"
    git remote remove origin
    git remote add origin https://$GH_USER:$GH_TOKEN@github.com/flyve-mdm/flyve-mdm-ios-agent.git
fi
