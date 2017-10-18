Pod::Spec.new do |s|
  s.name             = 'ReadabilityKit'
  s.version          = '0.7.0'
  s.summary          = 'Metadata extractor for news, articles and full-texts.'
  
  s.homepage         = 'https://github.com/exyte/ReadabilityKit.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Exyte' => 'info@exyte.com' }
  s.source           = { :git => 'https://github.com/exyte/ReadabilityKit.git', :tag => s.version.to_s }
  s.social_media_url = 'http://www.exyte.com'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target    = '9.0'

  s.source_files = [
     'Sources/*.swift',
	 'Dependencies/Ji/*.swift'
  ]

  s.xcconfig = { 
	'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2',
	'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/ReadabilityKit/Dependencies/libxml2'
  }
  s.preserve_paths = 'Dependencies/libxml2/module.modulemap'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.libraries = 'xml2'

end
