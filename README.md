# Mock Chat App
> Messaging app that echo's any text sent.

[![Language](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)]
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)]

## Version

1.0

## Requirements

- iOS 13.0+
- Xcode 11+

## Getting Started

1. First download the project by cloning this repository on Xcode or by downloading the Zip file.
2. Select the application in the scheme in case it is not selected automatically
3. Select any iPhone Simulator to run the app on.

## Pods used

```ruby
pod 'RealmSwift'
pod 'SnapKit'
pod 'GrowingTextView'
pod 'SwiftDate'
```

## Summary

The first page that has the chat list in it is a table view controller. The number of users is set from the app, however all the users are generated once when the app is newly installed, then all data are saved localy. 

At first all items in the chat list appear as image with light gray color and a random user name, when an item is clicked it redirects to the chat view controller.

In the chat view controller any text sent is echoed 2 times and all message list is saved localy. When returning back to the chat list the users that is texted will be rearraged to the top of the list having the last message displayed with the timestamp and the image with turn green. 

The application also supports dark mode.

## Application Architecture

The Mock Message App follows the Model-View-Controller (MVC) design pattern and uses advances app development practices including Storyboards and Auto Layout.

## Features

- [x] Persist Locally
- [x] TextView Delegates
- [x] TableView Delegate
- [x] Nib files
- [x] Extensions
- [x] Enumerations

