#!/bin/sh

if [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
  fastlane beta
elif [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "true" ]]; then
  fastlane test
elif [[ "$TRAVIS_BRANCH" == "master" ]]; then
  if GIT_DIR=$PWD/.git git rev-parse "$1^{tag}" >/dev/null 2>&1 
  then
    standard-version
    fastlane release
  fi
fi
