#
# Be sure to run `pod lib lint Index.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Index'
  s.version          = '1.0.2'
  s.summary          = 'Index helps with data collection for cells like UITableViewCell giving more information besides only the object'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Index has Row, Section, and SectionRow as your data provider for collection of views. You can transform Object into Row<Object> easily. The Section is for data that has the same feeling for section with rows and you can transform them into Section or SectionRow with you want to have a one-dimensional data.
                       DESC

  s.homepage         = 'https://github.com/umobi/Index'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brennobemoura@outlook.com' }
  s.source           = { :git => 'https://github.com/umobi/Index.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = "5.1"

  s.source_files = 'Index/Classes/**/*'
  
  s.subspec 'Bindable' do |s|
        s.source_files = "Bindable/**/*"
        s.dependency "UMUtils/ViewModel"
        s.dependency "RxSwift"
        s.dependency "RxCocoa"
  end
  
  s.subspec 'Container' do |s|
      s.source_files = "Container/**/*"
      s.dependency "Index/Bindable"
      s.dependency "UIContainer", '~> 1.1.0'
  end
end
