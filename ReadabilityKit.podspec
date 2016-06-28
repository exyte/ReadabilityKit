Pod::Spec.new do |s|
  s.name             = 'ReadabilityKit'
  s.version          = '0.4.0'
  s.summary          = 'Metadata extractor for news, articles and full-texts'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Exyte' => 'info@exyte.com' }
  s.source           = { :git => 'https://github.com/exyte/ReadabilityKit.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = "10.9"

  s.source_files = 'ReadabilityKit/Classes/**/*'

  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'Ji', '~> 1.2.0'
end
