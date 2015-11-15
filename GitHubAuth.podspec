#
# Be sure to run `pod lib lint GitHubAuth.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GitHubAuth"
  s.version          = "0.1.0"
  s.summary          = "Dead simple github login"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
                       The swift library for signing in with GitHub. That's all.
                       DESC

  s.homepage         = "https://github.com/tnantoka/GitHubAuth"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "tnantoka" => "tnantoka@bornneet.com" }
  s.source           = { :git => "https://github.com/tnantoka/GitHubAuth.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/tnantoka'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'GitHubAuth' => ['Pod/Assets/*.storyboard']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
