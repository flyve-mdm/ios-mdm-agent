#!/bin/sh

if [[ ("$TRAVIS_BRANCH" == "develop" || "$TRAVIS_BRANCH" == "master") && "$TRAVIS_PULL_REQUEST" == "true" ]]; then
    fastlane test
elif [[ "$TRAVIS_BRANCH" != "develop" && "$TRAVIS_BRANCH" != "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
    xcodebuild clean build -workspace ${APPNAME}.xcworkspace -scheme $APPNAME
fi
