#!/bin/sh

# Update gem
gem update --system
# install Node Version Manager
nvm install stable
# Use stable version
nvm use stable
# Install fastlane last version
gem install fastlane --no-rdoc --no-ri --no-document --quiet
# Install jq for json parse
brew install jq
# Install standard-version scope global
npm i -g standard-version
# Install conventional-github-releaser scope global
npm install -g conventional-github-releaser
# Install libs from package.json
npm install
