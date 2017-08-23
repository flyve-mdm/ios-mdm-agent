#!/bin/sh

echo -----------------CHANGELOG-------------------
if [[ "$TRAVIS_BRANCH" == "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
echo ------------------CONFIG--------------------
git config --global user.email $GH_EMAIL
git config --global user.name "Travis CI"
git remote rm origin
git remote add origin https://$GH_USER:${GH_TOKEN}@github.com/flyve-mdm/flyve-mdm-ios-agent.git
echo ------------------RELEASE--------------------
npm run release
git clean -f
git push origin -u master
fi