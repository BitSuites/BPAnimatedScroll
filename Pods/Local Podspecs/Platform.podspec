#
# Be sure to run `pod spec lint Platform.podspec' to ensure this is a
# valid spec.
#
# Remove all comments before submitting the spec. Optional attributes are commented.
#
# For details see: https://github.com/CocoaPods/CocoaPods/wiki/The-podspec-format
#
Pod::Spec.new do |s|
  s.name         = "Platform"
  s.version      = "0.0.1"
  s.summary      = "A base platform to use with all BitSuites projects."
  s.homepage     = "http://www.bitsuites.com"
  s.license      = 'MIT'
  s.author       = { "Cory Imdieke" => "coryi@bitsuites.com" }

  s.source       = { :git => "git@github.com:BitSuites/Platform.git" }
  s.platform     = :ios, '6.0'

  s.source_files = 'Additions/**/*.{h,m}', 'Helpers/**/*.{h,m}'

  s.frameworks = 'MapKit', 'CoreLocation', 'QuartzCore', 'Accelerate'

  s.requires_arc = true

  s.preserve_paths = 'Platform.xcodeproj', 'PlatformResources', 'Additions'

  # If you need to specify any other build settings, add them to the
  # xcconfig hash.
  #
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

  # Finally, specify any Pods that this Pod depends on.
  #
  s.dependency 'KGNoise', '~> 1.2.0'
  s.dependency 'UIAlertView-Blocks', '~> 0.0.1'
  s.dependency 'OpenInChrome', '~> 0.0.1'
  
  s.resource_bundles = {
    'MVSimpleWebBrowserResources' => ['Additions/MVSimpleWebBrowser/Resources/*'],
    'MVSingleItemEditorResources' => ['Additions/MVSingleItemEditor/*.xib']
  }

end
