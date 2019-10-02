#
# Be sure to run `pod lib lint Index.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Index'
  s.version          = '1.0.0-beta1'
  s.summary          = 'A short description of Index.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/brennobemoura/Index'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/brennobemoura/Index.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = "5.1"

  s.source_files = 'Index/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Index' => ['Index/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.subspec 'Bindable' do |s|
        s.source_files = "Bidable/**/*"
        s.dependency "UMUtils/ViewModel"
        s.dependency "RxSwift"
        s.dependency "RxCocoa"
  end
  
  s.subspec 'Container' do |s|
      s.source_files = "Container/**/*"
      s.dependency "Index/Bindable"
  end
end
