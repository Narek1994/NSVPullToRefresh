#
# Be sure to run `pod lib lint NSVPullToRefresh.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NSVPullToRefresh'
  s.version          = '0.1.0'
  s.summary          = 'PullToRefresh for any kind of view.'
  s.swift_version = '5.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  NSVPullToRefresh allows you to add pull to refresh to any kind of UIView. It automatically handles child ScrollView(TableView,CollectionView) scrolls if there is one, without blocking other gestures added to the view.
                       DESC

  s.homepage         = 'https://github.com/Narek1994/NSVPullToRefresh'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Narek1994' => 'nareksimonyan94@gmail.com' }
  s.source           = { :git => 'https://github.com/Narek1994/NSVPullToRefresh.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'NSVPullToRefresh/Classes/**/*'
  
  # s.resource_bundles = {
  #   'NSVPullToRefresh' => ['NSVPullToRefresh/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
