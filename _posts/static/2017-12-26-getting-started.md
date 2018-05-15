---
layout: post
howtos: true
published: true
title: Getting started
permalink: howtos/getting-started
description: Welcome to Flyve MDM
category: user
date: 2018-01-14
---
The Flyve MDM Agent for iOS allows you to manage the iOS devices belonging to your company's IT infrastructure, everything from the [Web Dashboard](http://flyve.org/web-mdm-dashboard/) or [plugin for GLPI](http://flyve.org/glpi-plugin/), the later ideal for those who already work with this IT and asset management software.

Flyve MDM is a Mobile device management software that enables you to secure and manage all the mobile devices of your business or family.

## 1. Invite the user

The invitation is sent to the email account of the user, the invitation has a deeplink, once it is opened from the device...

* If the Agent is installed, it will Open with the App

<img src="https://github.com/Naylin15/Screenshots/blob/master/ios-agent/open-mdm.png?raw=true" alt="MDM Agent" width="300">

* If it isn't installed, it will take the user to the App Store.

## 2. Enrollment

The Agent counts with an intuitive and simple User Interface through all the enrollment process

<br>

<div>
<img src="https://github.com/Naylin15/Screenshots/blob/master/ios-agent/enroll.png?raw=true" alt="Start Enrollment" width="300">

<img src="https://github.com/Naylin15/Screenshots/blob/master/ios-agent/enrollment.png?raw=true" alt="Enrollment" width="300">
</div>

## 3. Manage your fleet

From there on the Agent will allow to implement in the device the following features from the Dashboard:

* Configure and deploy your fleet
* Connectivity Access
* Security Features
* Mobile Fleet Inventory
* Applications management

### MQ Telemetry Transport

We implemented the MQTT, useful machine to machine protocol, for connections with remote locations since it was designed as an extremely lightweight message transport. It is also ideal for mobile applications due to its small size, low power usage, minimised data packets, and efficient distribution of information to one or many receivers. Thanks to it, the Agent is capable of maintaining a connection with the backend

### Information

The Agent will display the relevant information, the user will be able to see the Supervisor information and edit his own

<img src="https://github.com/Naylin15/Screenshots/blob/master/ios-agent/information.png?raw=true" alt="Status Online" width="300">