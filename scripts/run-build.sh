#!/bin/sh

if [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
  fastlane beta
elif [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "true" ]]; then
  fastlane test
elif [[ "$TRAVIS_BRANCH" == "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then

  if GIT_DIR=$PWD/.git git rev-parse "$1^{tag}" >/dev/null 2>&1 
  then
    npm run release
  else
    npm run release -- --first-release
  fi
  # Get version number from package
  export GIT_TAG=$(jq -r ".version" package.json)

  fastlane release
fi
