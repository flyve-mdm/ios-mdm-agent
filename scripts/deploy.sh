#!/bin/sh

if [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
  fastlane beta

elif [[ "$TRAVIS_BRANCH" == "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then
    git config --global user.email $GH_EMAIL
    git config --global user.name "Flyve MDM"
    git remote remove origin
    git remote add origin https://$GH_USER:$GH_TOKEN@github.com/flyve-mdm/flyve-mdm-ios-agent.git

    git checkout $TRAVIS_BRANCH -f
    # Generate CHANGELOG.md and increment version
    npm run release -- -t '' -m "ci(release): generate **CHANGELOG.md** for version %s"
    # Push tag to github
    conventional-github-releaser -t $GH_TOKEN -r 0
    # Get version number from package.json
    export GIT_TAG=$(jq -r ".version" package.json)
    # Update CFBundleShortVersionString
    /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${GIT_TAG}" ${PWD}/${APPNAME}/Info.plist
    # Add modified and delete files
    git add -u
    # Create commit
    git commit -m "ci(build): increment **version** ${GIT_TAG}"
    # Push commits and tags to origin branch
    git push --follow-tags origin $TRAVIS_BRANCH

    fastlane release
fi
