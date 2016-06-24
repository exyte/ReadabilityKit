# ReadabilityKit

[![CI Status](http://img.shields.io/travis/Victor Sukochev/ReadabilityKit.svg?style=flat)](https://travis-ci.org/Victor Sukochev/ReadabilityKit)
[![Version](https://img.shields.io/cocoapods/v/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![License](https://img.shields.io/cocoapods/l/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![Platform](https://img.shields.io/cocoapods/p/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)

ReadabilityKit is an HTML meta data parser library written in Swift.

## Features

Extracting:

- [x] Title
- [x] Description
- [x] Title image url
- [x] Keywords

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ 

## Usage

```swift
let parser = Readability(data: htmlData)

let title = parser.title()
let description = parser.description()
let keywords = parser.keywords()
let imageUrl = parser.imageUrl()
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

ReadabilityKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ReadabilityKit"
```

## Author

Exyte, exyte.com

## License

ReadabilityKit is available under the MIT license. See the LICENSE file for more info.
