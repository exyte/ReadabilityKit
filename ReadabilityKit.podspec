#
# Be sure to run `pod lib lint ReadabilityKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ReadabilityKit'
  s.version          = '0.1.0'
  s.summary          = 'HTML document meta info extractor.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

 # s.description      = <<-DESC
#ODO: Add long description of the pod here.
#                       DESC

  s.homepage         = 'https://github.com/exyte/ReadabilityKit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Victor Sukochev' => 'sukochevvv@gmail.com' }
  s.source           = { :git => 'https://github.com/exyte/ReadabilityKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ReadabilityKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ReadabilityKit' => ['ReadabilityKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'Ji', '~> 1.2.0'
end
