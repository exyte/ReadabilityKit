Pod::Spec.new do |s|
  s.name             = 'ReadabilityKit'
  s.version          = '0.1.0'
  s.summary          = 'HTML document meta info extractor.'
                      DESC

  s.homepage         = 'https://github.com/exyte/ReadabilityKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Exyte' => 'exyte.com' }
  s.source           = { :git => 'https://github.com/exyte/ReadabilityKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = "10.9"

  s.source_files = 'ReadabilityKit/Classes/**/*'

  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'Ji', '~> 1.2.0'
end
