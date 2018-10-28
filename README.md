# MDM Agent for iOS

![Flyve MDM banner](https://user-images.githubusercontent.com/663460/26935464-54267e9c-4c6c-11e7-86df-8cfa6658133e.png)

[![License](https://img.shields.io/badge/license-LGPL_v3.0-blue.svg)](https://github.com/flyve-mdm/ios-mdm-agent/blob/develop/LICENSE.md)
[![Follow twitter](https://img.shields.io/twitter/follow/FlyveMDM.svg?style=social&label=Twitter&style=flat-square)](https://twitter.com/FlyveMDM)
[![Project Status: WIP](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)
[![Telegram Group](https://img.shields.io/badge/Telegram-Group-blue.svg)](https://t.me/flyvemdm)
[![IRC Chat](https://img.shields.io/badge/IRC-%23flyvemdm-green.svg)](http://webchat.freenode.net/?channels=flyve-mdm)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![Greenkeeper badge](https://badges.greenkeeper.io/flyve-mdm/ios-mdm-agent.svg)](https://greenkeeper.io/)
[![GitHub release](https://img.shields.io/github/release/flyve-mdm/ios-mdm-agent.svg)](https://github.com/flyve-mdm/ios-mdm-agent/releases)

Flyve MDM is a Mobile device management software that enables you to secure and manage all the mobile devices of your business or family via a web-based console.

To get started, check out [Flyve MDM Website](https://flyve-mdm.com/)!

## Table of contents

* [Synopsis](#synopsis)
* [Build Status](#build-status)
* [Installation](#installation)
* [Documentation](#documentation)
* [Compatibility Charts](#compatibility-charts)
* [Versioning](#versioning)
* [Contact](#contact)
* [Professional Services](#professional-services)
* [Contribute](#contribute)
* [Copying](#copying)

## Synopsis

The iOS Agent will manage all your mobile devices effectively, including a range of powerful security features to protect sensitive company data stored on mobile devices, allowing you to manage your mobile fleet security policy with precision.

The iOS Agent will help you to:

* Configure and deploy your mobile fleet from the web-based administration console
* Install and uninstall remote applications
* Send files remotely to all terminals
* Deploy and control Bluetooth and Wi-Fi connectivity
* Activate real-time geolocation of your terminals
* Delete, partially or totally, your data in case of loss or theft
* Create an inventory of all of your company terminals
* Keep control and protect yourself from cyber-attacks:
  * Set the level of complexity of your passwords
  * Activate mobile device encryption
  * Lock the mobile device remotely
  * Control the authorisation for the use of the camera
  * Erase all data from the remote terminal (reset)

For more information visit our [Official Website](http://flyve.org/ios-mdm-agent/).

## Build Status

| **LTS** | **Bleeding Edge** |
|:---:|:---:|
| [![Build Status](https://circleci.com/gh/flyve-mdm/ios-mdm-agent/tree/master.svg?style=svg)](https://circleci.com/gh/flyve-mdm/ios-mdm-agent/tree/master) | [![Build Status](https://circleci.com/gh/flyve-mdm/ios-mdm-agent/tree/develop.svg?style=svg)](https://circleci.com/gh/flyve-mdm/ios-mdm-agent/tree/develop) |

## Installation

Flyve MDM Agent for iOS is running on iOS 9.3 and higher.

Download the latest IPA, from GitHub releases, TestFlight or Apple Store.

[<img src="https://user-images.githubusercontent.com/663460/26986739-23bffc6e-4d49-11e7-92a2-cdba1b517a08.png" alt="Download from iTunes" height="60">](https://itunes.apple.com/us/app/flyve-mdm-agent)
[<img src="https://user-images.githubusercontent.com/663460/30159664-a0e818f4-93c9-11e7-9937-501201c36709.png" alt="Download IPA from GitHub" height="60">](https://github.com/flyve-mdm/ios-mdm-agent/releases/latest)

## Documentation

We maintain a detailed documentation of the project on the website, check the [How-tos](http://flyve.org/ios-mdm-agent/howtos/) and [Development](http://flyve.org/ios-mdm-agent/) section.

## Compatibility Charts

### iPhones

| | iOS 9.3 | iOS 10+ | iOS 11+ | iOS 12+ |
|:-----:|:-----:|:-----:|:-----:|:-----:|
|**iPhone 4s**|✔︎||||
|**iPhone 5**|✔︎|✔︎|||
|**iPhone 5C**|✔︎|✔︎|||
|**iPhone 5S**|✔︎|✔︎|✔︎|✘|
|**iPhone 6 / 6+**|✔︎|✔︎|✔︎|✘|
|**iPhone 6S / 6S+**|✔︎|✔︎|✔︎|✘|
|**iPhone SE**|✔︎|✔︎|✔︎|✘|
|**iPhone 7 / 7+**||✔︎|✔︎|✘|
|**iPhone 8 / 8+**|||✔︎|✘|
|**iPhone X**|||✔︎|✘|
|**iPhone XS / XS Max**||||✘|
|**iPhone XR**||||✘|

### iPads

| | iOS 9.3 | iOS 10+ | iOS 11+ | iOS 12+ |
|:-----:|:-----:|:-----:|:-----:|:-----:|
|**iPad 2**|✔︎||||
|**iPad (3rd)**|✔︎|✔︎|||
|**iPad mini**|✔︎|✔︎|||
|**iPad (4th)**|✔︎|✔︎|✔︎|✘|
|**iPad Air**|✔︎|✔︎|✔︎|✘|
|**iPad mini 2**|✔︎|✔︎|✔︎|✘|
|**iPad Air 2**|✔︎|✔︎|✔︎|✘|
|**iPad mini 3**|✔︎|✔︎|✔︎|✘|
|**iPad mini 4**|✔︎|✔︎|✔︎|✘|
|**iPad Pro 9.7" (1st)**|✔︎|✔︎|✔︎|✘|
|**iPad Pro 12.9" (1st)**|✔︎|✔︎|✔︎|✘|
|**iPad (2017)**||✔︎|✔︎|✘|
|**iPad Pro 9.7" (2nd)**||✔︎|✔︎|✘|
|**iPad Pro 12.9" (2nd)**||✔︎|✔︎|✘|
|**iPad (2018)**|||✔︎|✘|

## Versioning

In order to provide transparency on our release cycle and to maintain backward compatibility, Flyve MDM is maintained under [the Semantic Versioning guidelines](http://semver.org/). We are committed to following and complying with the rules, the best we can.

See [the tags section of our GitHub project](https://github.com/flyve-mdm/ios-mdm-agent/tags) for changelogs for each release version of Flyve MDM. Release announcement posts on [the official Teclib' blog](http://www.teclib-edition.com/en/communities/blog-posts/) contain summaries of the most noteworthy changes made in each release.

## Contact

For notices about major changes and general discussion of Flyve MDM development, subscribe to the [/r/FlyveMDM](http://www.reddit.com/r/FlyveMDM) subreddit.
You can also chat with us via IRC in [#flyve-mdm on freenode](http://webchat.freenode.net/?channels=flyve-mdm) or [@flyvemdm on Telegram](https://t.me/flyvemdm).
Ping me @hectorerb if you get stuck.

## Professional Services

The Flyve MDM and GLPI Network services are available through our [Partner's Network](http://www.teclib-edition.com/en/partners/). We provide special training, bug fixes with editor subscription, contributions for new features, and more.

Obtain a personalized service experience, associated with benefits and opportunities.

## Contribute

Want to file a bug, contribute some code, or improve documentation? Excellent! Read up on our
guidelines for [contributing](./CONTRIBUTING.md) and then check out one of our issues in the [Issues Dashboard](https://github.com/flyve-mdm/ios-mdm-agent/issues).

## Copying

* **Name**: [Flyve MDM](https://flyve-mdm.com/) is a registered trademark of [Teclib'](http://www.teclib-edition.com/en/).
* **Code**: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License ([LGPLv3](https://www.gnu.org/licenses/lgpl-3.0.en.html)).
* **Documentation**: released under Attribution 4.0 International ([CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)).
