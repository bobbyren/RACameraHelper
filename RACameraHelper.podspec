#
# Be sure to run `pod lib lint RACameraHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RACameraHelper'
  s.version          = '0.1.1'
  s.summary          = 'Easier way to use the image picker'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      =  <<-DESC
Load the camera or photo library more easily with simpler callbacks. Loads a working photo cropper that fixes an Apple bug with cropping bounds.
DESC

  s.homepage         = 'https://github.com/bobbyren/RACameraHelper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bobby' => 'bobbyren@gmail.com' }
  s.source           = { :git => 'https://github.com/bobbyren/RACameraHelper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'RACameraHelper/Classes/**/*'
  s.swift_version = '3.3'
   s.resource_bundles = {
     'RACameraHelper' => ['RACameraHelper/Assets/*.{storyboard}']
   }


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
