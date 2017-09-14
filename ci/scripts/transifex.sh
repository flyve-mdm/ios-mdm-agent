#!/bin/sh

#   Copyright © 2017 Teclib. All rights reserved.
#
# transifex.sh is part of flyve-mdm-ios
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
# @link      https://flyve-mdm.com
# ------------------------------------------------------------------------------

echo ------------------- Configure Transifex --------------------
# Configure Transifex on develop branch
# Create config file transifex
sudo echo $'[https://www.transifex.com]\nhostname = https://www.transifex.com\nusername = '"$TRANSIFEX_USER"$'\npassword = '"$TRANSIFEX_API_TOKEN"$'\ntoken = '"$TRANSIFEX_API_TOKEN"$'\n' > ~/.transifexrc

# Move to local branch
git checkout $CIRCLE_BRANCH -f
# get transifex status
tx status
# push local files to transifex
tx push --source --no-interactive
# pull all the new language
tx pull --all --force
# if there are changes in lenguages
if [[ -z $(git status -s) ]]; then
    echo "tree is clean"
else
    git add -u
    git commit -m "ci(localization): download languages from **Transifex**"
fi
