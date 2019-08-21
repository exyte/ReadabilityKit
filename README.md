<img src="https://github.com/exyte/ReadabilityKit/blob/new-demo/header.png">
<img align="right" src="https://raw.githubusercontent.com/exyte/ReadabilityKit/new-demo/demo.gif" width="480" />

<p><h1 align="left">ReadabilityKit</h1></p>

<p><h4>Extract a relevant preview (title, description, image and video) from URL</h4></p>

___

<p> We are a development agency building
  <a href="https://clutch.co/profile/exyte#review-731233">phenomenal</a> apps.</p>

</br>

<a href="https://exyte.com/contacts"><img src="https://i.imgur.com/vGjsQPt.png" width="134" height="34"></a> <a href="https://twitter.com/exyteHQ"><img src="https://i.imgur.com/DngwSn1.png" width="165" height="34"></a>

</br></br>

[![CI Status](http://img.shields.io/travis/exyte/ReadabilityKit.svg?style=flat)](https://travis-ci.org/exyte/ReadabilityKit)
[![Version](https://img.shields.io/cocoapods/v/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-0473B3.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![Platform](https://img.shields.io/cocoapods/p/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)


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

swift 5.x:
```ogdl
github "exyte/ReadabilityKit"
```

swift 4.x:
```ogdl
github "exyte/ReadabilityKit" "0.7.1"
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

## License

ReadabilityKit is available under the MIT license. See the LICENSE file for more info.
