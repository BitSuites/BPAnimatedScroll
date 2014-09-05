BitSuites Platform for iOS
==========================

A base platform to use with all BitSuites projects.

### Project Installation ###

Installation is handled using Cocoapods.

`pod 'Platform', :git => "git@github.com:BitSuites/Platform.git"`

This will point to the head of the Platform repository and will grab any changes as necessary when a `pod install` command is issued. All project settings changes and configurations will be handled automatically. The only step after adding the Pod is to add `#import "Platform.h"` to the main project's Prefix file. Then be sure to use the newly generated Workspace instead of the Project file.
