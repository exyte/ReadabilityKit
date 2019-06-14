# ReadabilityKit

[![CI Status](http://img.shields.io/travis/exyte/ReadabilityKit.svg?style=flat)](https://travis-ci.org/exyte/ReadabilityKit)
[![Version](https://img.shields.io/cocoapods/v/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-0473B3.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![Platform](https://img.shields.io/cocoapods/p/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)

**NOTE**: ReadabilityKit is in maintenance mode. We recommend using [SwiftLinkPreview](https://github.com/LeonardoCardoso/SwiftLinkPreview) in the new code. 
We will continue to provide new releases with the latest versions of Xcode.

ReadabilityKit helps you to extract a relevant preview (title, description, image and video) from the URL.

The goal is to try and get the best extraction from the article for servicing applications that need to show a preview of a web URL along with an image.

Inspired by [snacktory](https://github.com/karussell/snacktory) and [newspaper](https://github.com/codelucas/newspaper).

## Demo
<img src="https://github.com/exyte/ReadabilityKit/blob/master/demo.gif" width="320px" height="569px" />

## Features

Extracts:

- [x] Title
- [x] Description
- [x] Top image
- [x] Top video
- [x] Keywords

## Requirements

- iOS 8.0+ / Mac OS X 10.10+ / tvOS 9.0+ / watchOS 2.0+

## Usage

```swift
let articleUrl = URL(string: "https://someurl.com/")!
Readability.parse(url: articleUrl, completion: { data in
  let title = data?.title
  let description = data?.description
  let keywords = data?.keywords
  let imageUrl = data?.topImage
  let videoUrl = data?.topVideo
})
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.
 
## Installation

#### [CocoaPods](http://cocoapods.org)
To install `ReadabilityKit`, simply add the following line to your Podfile

swift 5.x:
```swift
pod "ReadabilityKit"
```

swift 4.x:

```swift
pod 'ReadabilityKit' "0.7.1"
```

swift 3.2:

```swift
pod "ReadabilityKit", "0.6.0"
```

Legacy swift 2.3:

```swift
pod "ReadabilityKit", "0.5.4"
```

Legacy swift 2.2:

```
pod "ReadabilityKit", "0.5.2"
```

### [Carthage](http://github.com/Carthage/Carthage)

To integrate `ReadabilityKit` into your Xcode project using Carthage, specify it in your `Cartfile`

swift 4.x:
```ogdl
github "exyte/ReadabilityKit"
```

swift 3.2:
```ogdl
github "exyte/ReadabilityKit" "0.6.0"
```

Legacy swift 2.3:
```ogdl
github "exyte/ReadabilityKit" "0.5.4"
```

Legacy swift 2.2:

```ogdl
github "exyte/ReadabilityKit" "0.5.2"
```

#### Manually

1. Install [Ji XML parser](https://github.com/honghaoz/Ji#manually)
2. Download and drop all files from Sources folder in your project
3. Congratulations!

## Author

This project is maintained by [exyte](https://exyte.com). We design and build mobile and VR/AR applications.

## License

ReadabilityKit is available under the MIT license. See the LICENSE file for more info.
