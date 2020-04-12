#
# Be sure to run `pod lib lint Index.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Index'
  s.version          = '1.1.1'
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
  s.author           = { 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/Index.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = "5.1"

  s.default_subspec = "Core"

  s.subspec 'Core' do |s|
        s.source_files = "Sources/Index/Core/**/*.swift"
  end
  
  s.subspec 'IndexBindable' do |s|
        s.source_files = "Sources/Index/IndexBindable/**/*.swift"

        s.dependency "Index/Core"
        s.dependency "UMUtils/UMViewModel", "~> 1.1.3"
        s.dependency "RxSwift", "~> 5.0.0"
        s.dependency "RxCocoa", "~> 5.0.0"
  end
  
  s.subspec 'IndexContainer' do |s|
      s.source_files = "Sources/Index/IndexContainer/**/*.swift"

      s.dependency "Index/IndexBindable"
      s.dependency "UIContainer", '~> 1.2.0-beta.9'
  end
end
