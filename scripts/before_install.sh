#!/bin/sh

echo ----------- Create Fastlane environment variables ------------
# Create Fastlane environment variables
echo FASTLANE_PASSWORD=$FASTLANE_PASSWORD >> .env
echo TELEGRAM_WEBHOOKS=$TELEGRAM_WEBHOOKS >> .env
echo GIT_REPO=$TRAVIS_REPO_SLUG >> .env
echo GIT_BRANCH=$TRAVIS_BRANCH >> .env
