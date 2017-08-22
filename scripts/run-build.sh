#!/bin/sh

if [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
  fastlane beta
elif [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "true" ]]; then
  fastlane test
elif [[ "$TRAVIS_BRANCH" == "feature/version" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then

  echo ------------------CONFIG--------------------
  git config --global user.email $GH_EMAIL
  git config --global user.name "Travis CI"
  git remote rm origin
  git remote add origin https://$GH_USER:${GH_TOKEN}@github.com/flyve-mdm/flyve-mdm-ios-agent.git

  if GIT_DIR=$PWD/.git git rev-parse "$1^{tag}" >/dev/null 2>&1 
  then
    npm run release
  else
    npm run release -- --first-release
  fi
  # Get version number from package
  export GIT_TAG=$(jq -r ".version" package.json)

  # Update CFBundleShortVersionString
  /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${GIT_TAG}" ${PWD}/${APPNAME}/Info.plist

  # Rename last commit
  git commit -a --amend -m "ci(release): generate CHANGELOG.md for version ${GIT_TAG}"

  git push origin -u feature/version
  # fastlane release
fi
