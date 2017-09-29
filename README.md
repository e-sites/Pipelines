# ![Pipelines](Assets/Icon.png) Pipelines

> Adds your build states for your [Buildkite](https://buildkite.com) builds to your statusbar.

[![forthebadge](http://forthebadge.com/images/badges/compatibility-emacs.svg)](http://forthebadge.com) [![forthebadge](http://forthebadge.com/images/badges/60-percent-of-the-time-works-every-time.svg)](http://forthebadge.com)

## Example

![Screenshot](Assets/statusbar_screenshot.png)
> 💡 Tapping on the build states will open [buildkite.com/builds](https://buildkite.com/builds).

**Closing?**   
(Force) quit `BuildKite-Pipelines` through the Activity Monitor

## Requirements
 - Xcode 9
 - Swift 4
 - Cocoapods 1.3
 - apollo-codegen 0.17.0-alpha.7

## Installation

### Apollo
*Requires `node`*

```
npm install -g apollo-codegen@0.17.0-alpha.7
```

### Cocoapods
```
pod install
```

### GraphQL API Token
Go to [buildkite.com/user/api-access-tokens](https://buildkite.com/user/api-access-tokens) and generate a new API token.   

- Make sure you enable `GraphQL Beta (graphql)`

## Configuration
Open `Classes/Constants.swift`.  

 - Set `token` to your API token
 - `totalBuilds`: The number of builds you want to monitor (the last x)
 - `fetchInterval`: At what time interval (seconds) should the app check 

## Dependencies
 - [Apollo](https://github.com/apollographql/apollo-ios)
 - [Macaw](https://github.com/exyte/Macaw)
 - [SwiftyUserDefaults](https://github.com/radex/SwiftyUserDefaults)

## Todo
- [x] Notifications
- [ ] Make context menu to show build information

---
⚠️ *This is an unoffical app, Buildkite is in no way responsible for this or anything related to this particular product*