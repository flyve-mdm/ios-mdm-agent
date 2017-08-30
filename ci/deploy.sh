#!/bin/sh

#   Copyright © 2017 Teclib. All rights reserved.
#
# deploy.sh is part of flyve-mdm-ios
#
# flyve-mdm-ios is a subproject of Flyve MDM. Flyve MDM is a mobile
# device management software.
#
# flyve-mdm-ios is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# flyve-mdm-ios is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# ------------------------------------------------------------------------------
# @author    Hector Rondon
# @date      25/08/17
# @copyright Copyright © 2017 Teclib. All rights reserved.
# @license   GPLv3 https://www.gnu.org/licenses/gpl-3.0.html
# @link      https://github.com/flyve-mdm/flyve-mdm-ios-agent
# @link      https://.flyve-mdm.com
# ------------------------------------------------------------------------------

git config --global user.email $GH_EMAIL
git config --global user.name "Flyve MDM"
git remote remove origin
git remote add origin https://$GH_USER:$GH_TOKEN@github.com/flyve-mdm/flyve-mdm-ios-agent.git

if [[ "$TRAVIS_BRANCH" == "develop" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then

    if [[ $TRAVIS_COMMIT_MESSAGE != *"**beta**"* ]]; then
        git checkout $TRAVIS_BRANCH -f
        # Generate CHANGELOG.md and increment version
        npm run release -- -t ''
        # Get version number from package.json
        export GIT_TAG=$(jq -r ".version" package.json)
        # Revert last commit
        git reset --hard HEAD~1
        # Update CFBundleShortVersionString
        /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString ${GIT_TAG}-beta" ${PWD}/${APPNAME}/Info.plist
        # Add modified and delete files
        git add ${APPNAME}/Info.plist
        # Create commit
        git commit -m "ci(beta): generate **beta** for version ${GIT_TAG}-beta"
        # Push commits to origin branch
        git push origin $TRAVIS_BRANCH

        fastlane beta
    fi

elif [[ "$TRAVIS_BRANCH" == "master" && "$TRAVIS_PULL_REQUEST" == "false" ]]; then

    if [[ $TRAVIS_COMMIT_MESSAGE != *"**version**"* && $TRAVIS_COMMIT_MESSAGE != *"**CHANGELOG.md**"* ]]; then
        git checkout $TRAVIS_BRANCH -f
        # Generate CHANGELOG.md and increment version
        npm run release -- -t '' -m "ci(release): generate **CHANGELOG.md** for version %s"
        # Push tag to github
        # conventional-github-releaser -t $GH_TOKEN -r 0
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

        # Update CHANGELOG.md on gh-pages
        git fetch origin gh-pages
        git checkout gh-pages
        git checkout $TRAVIS_BRANCH CHANGELOG.md

        # Create header content
        HEADER="---\nlayout: modal\ntitle: changelog\n---\n"
        # Duplicate CHANGELOG.md
        cp CHANGELOG.md CHANGELOG_COPY.md
        # Add header to CHANGELOG.md
        (echo $HEADER ; cat CHANGELOG_COPY.md) > CHANGELOG.md
        # Remove CHANGELOG_COPY.md
        rm CHANGELOG_COPY.md

        fastlane release
    fi
fi
