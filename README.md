<img src="https://github.com/exyte/ReadabilityKit/blob/master/Assets/header.png">
<img align="right" src="https://raw.githubusercontent.com/exyte/ReadabilityKit/master/Assets/demo.gif" width="480" />

<p><h1 align="left">ReadabilityKit</h1></p>

<p><h4>Preview extractor for news, articles and full-texts in Swift</h4></p>

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
- [x] Date

## Usage

```swift
let articleUrl = URL(string: "https://someurl.com/")!
Readability.parse(url: articleUrl, completion: { data in
    let title = data?.title
    let description = data?.description
    let keywords = data?.keywords
    let imageUrl = data?.topImage
    let videoUrl = data?.topVideo
    let datePublished = data?.datePublished
})
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.
 
## Installation

### [CocoaPods](http://cocoapods.org)

```ruby
pod 'ReadabilityKit'
```

### [Carthage](http://github.com/Carthage/Carthage)

```ogdl
github "exyte/ReadabilityKit"
```

### Manually

1. Install [Ji XML parser](https://github.com/honghaoz/Ji#manually).
2. Download and drop all files from Sources folder in your project.

## Development Environment Setup

1. Install [Carthage](https://github.com/Carthage/Carthage#installing-carthage).
2. Check out and build the project's dependencies:

```bash
carthage bootstrap --platform <name>
```

## Requirements

- iOS 10.0+ / macOS 10.12+ / tvOS 10.0+ / watchOS 3.0+

## License

ReadabilityKit is available under the MIT license. See the LICENSE file for more info.
