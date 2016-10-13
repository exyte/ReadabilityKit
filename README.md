# ReadabilityKit

[![CI Status](http://img.shields.io/travis/exyte/ReadabilityKit.svg?style=flat)](https://travis-ci.org/exyte/ReadabilityKit)
[![Version](https://img.shields.io/cocoapods/v/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-0473B3.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/cocoapods/l/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)
[![Platform](https://img.shields.io/cocoapods/p/ReadabilityKit.svg?style=flat)](http://cocoapods.org/pods/ReadabilityKit)

ReadabilityKit helps you to extract a relevant preview (title, description, image and video) from the URL.

The goal is to try and get the best extraction from the article for servicing applications that need to show a preview of a web URL along with an image. Comparison with other extraction libraries available [here](https://github.com/exyte/ReadabilityKit#comparison-with-other-libraries). Comparison with another iOS extraction library  ([SwiftLinkPreview](https://github.com/LeonardoCardoso/SwiftLinkPreview)) available [here](https://github.com/exyte/ReadabilityKit#readabilitykit-vs-swiftlinkpreview).

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
Readability.parse(url: articleUrl, { data in
  let title = data?.title
  let description = data?.description
  let keywords = data?.keywords
  let imageUrl = data?.topImage
  let videoUrl = data?.topVideo
})
```

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Comparison with other libraries

|  | [ReadabilityKit](https://github.com/exyte/ReadabilityKit) | [SwiftLinkPreview](https://github.com/LeonardoCardoso/SwiftLinkPreview) | [python-goose](https://github.com/grangier/python-goose) | [snacktory](https://github.com/karussell/snacktory) | [newspaper](https://github.com/codelucas/newspaper)
|---|---|---|---|---|---|
| [github](https://github.com/exyte/ReadabilityKit) | ✅ | ✅ | ✅ | ✅ | ✅ |
| [washingtonpost](https://www.washingtonpost.com/business/on-it/mantech-expands-cybersecurity-work/2015/06/16/85934832-143a-11e5-9518-f9e0a8959f32_story.html) | ✅ | ✅ | ✅ | ✅ | ✅ |
| [youtube](https://www.youtube.com/watch?v=ky3OcJR-5N4) | ✅ | ❌ |☑️ | ✅ | ☑️ | 
| [vimeo](https://vimeo.com/177533449) | ✅ | ❌ |✅ | ✅ | ☑️ | 
| [instagram](https://www.instagram.com/p/BIk6ZSEhbzs/) | ✅ | ✅ | ☑️ | ✅ | ✅ | 
| [nytimes](http://www.nytimes.com/2016/06/26/magazine/how-an-archive-of-the-internet-could-change-history.html?_r=3) | ✅ | ✅ | ❌ | ✅ | ✅ | 
| [twitter](https://twitter.com/armadsen/status/680877848043728896) | ✅ | ☑️ | ❌ | ✅ | ❌ | 
| [medium](https://medium.com/friendship-dot-js/i-peeked-into-my-node-modules-directory-and-you-wont-believe-what-happened-next-b89f63d21558#.bc3z65o4k) | ✅ | ✅ | ✅ | ✅ | ✅ |
| [facebook](https://www.facebook.com/zuck/posts/10103010090805691?pnref=story) | ✅ | ☑️ | ☑️ | ☑️ | ✅ | 
| [imgur](http://imgur.com/J4A9PMH) | ✅ | ✅ | ✅ | ✅ | ✅ |
| [flickr](https://www.flickr.com/photos/adrianoabate/18883092533/in/photolist-hGZ97L-pZUGH9-qgCGxW-oLJmhn-uLCMwV-su6KFN-ckXE8m-hK937C-wnXkGj-bkeGc2-pTgJQy-oXBGLg-mVJDBz-spk2am-shRcng-sqCyKC-fCHnyi-wgpEVp-suLp4x-hB6Dsa-dX2zpg-k7RE1s-rRyFrf-fM8jbP-hoDSNW-sn6mwt-dbu7DG-w4XXPJ-dyzMaL-p4N6Ah-q56gLz-9hG4Z7-6hKWYE-cYQJrW-mNYioT-nWN2yp-frFCmW-qwQGPY-fDgCwn-v9thFV-eeqBH4-fV8pfs-fUSGwd-6tqnfs-pZNj28-kBFcYo-iENCVn-pTUCXU-dc6dGG-oKgiyk) | ✅ | ✅ | ❌ | ✅ | ✅ | 
| [500px](https://500px.com/photo/167038263/kate-by-alex-urban?ctx_page=1&from=popular) | ✅ | ❌ | ❌ | ✅ | ✅ 
| [dribbble](https://dribbble.com/shots/2889452-Almanac-Beer-Co-Craft-Pilsner) | ✅ | ✅ | ☑️ | ✅ | ✅ | 
| [lenta](https://lenta.ru/articles/2016/08/01/fskntrue/) | ✅ | ✅ | ☑️ | ✅ | ✅ |
| [habrahabr](https://habrahabr.ru/company/plarium/blog/307428/) | ✅ | ✅ | ☑️ | ✅ | ✅ |
| [bbc](http://www.bbc.com/news/world-asia-china-37081013) | ✅ | ✅ | ✅ | ✅ | ✅ |

✅ – correct
☑️ – partially correct
❌ – incorrect


#### ReadabilityKit vs [SwiftLinkPreview](https://github.com/LeonardoCardoso/SwiftLinkPreview)
- ReadabilityKit uses part of [ar90](https://github.com/masukomi/ar90-readability) algorithm which was transformed into the Redability.com product. This allows for more accurate extraction.
- Video support. ReadabilityKit detects videos on the page and extracts the most relevant to `Readability.topVideo`.
- Typed API that allows you to use statically typed properties without force casting.
- Keyword extraction.
 
## Installation

#### CocoaPods
ReadabilityKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile

swift 3.0:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'ReadabilityKit'
end
```

Legacy swift 2.3:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'ReadabilityKit', '0.5.4'
end
```

Legacy swift 2.2:

```ruby
platform :ios, '8.0'
use_frameworks!

target 'MyApp' do
    pod 'ReadabilityKit', '0.5.2'
end
```



### [Carthage](http://github.com/Carthage/Carthage)

To integrate `ReadabilityKit` into your Xcode project using Carthage, specify it in your `Cartfile`

swift 3.0:
```ogdl
github "exyte/ReadabilityKit"
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

This project is maintained by the [exyte](http://www.exyte.com) company, a team of experienced software engineers from the cold Siberia. We don't have bears and don't like vodka, but we love to create great applications! Just [contact us](mailto:info@exyte.com).

## License

ReadabilityKit is available under the MIT license. See the LICENSE file for more info.
