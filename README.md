# ReadabilityKit

[![CI Status](http://img.shields.io/travis/exyte/ReadabilityKit.svg?style=flat)](https://travis-ci.org/exyte/ReadabilityKit)
[![Version](https://img.shields.io/cocoapods/v/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![License](https://img.shields.io/cocoapods/l/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![Platform](https://img.shields.io/cocoapods/p/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)

ReadabilityKit helps you to extract a relevant metadata (for example, title, description and top image) from the URL. 

The extraction goal is to try and get the best extraction from the article for servicing applications that need to show a snippet of a web article along with an image.

Inspired by [goose](https://github.com/GravityLabs/goose) and [newspaper](https://github.com/codelucas/newspaper).

## Features

Extracts:

- [x] Title
- [x] Description
- [x] Top image
- [x] Keywords

## Requirements

- iOS 8.0+ / Mac OS X 10.9+ 

## Usage

```swift
let parser = Readability(url: articleUrl)

let title = parser.title()
let description = parser.description()
let keywords = parser.keywords()
let imageUrl = parser.imageUrl()
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.


## Installation

#### CocoaPods
ReadabilityKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'ReadabilityKit'
end
```
## Author

exyte, [info@exyte.com](mailto:info@exyte.com)

## License

ReadabilityKit is available under the MIT license. See the LICENSE file for more info.
