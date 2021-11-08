#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint linkfive_purchases.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'linkfive_purchases'
  s.version          = '0.0.1'
  s.summary          = 'Flutter LinkFive Purchases iOS'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://www.linkfive.io'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'LinkFive' => 'team@linkfive.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
