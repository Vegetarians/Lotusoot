#
#  Be sure to run `pod spec lint TestModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Lotusoot"
  s.version      = "0.0.2"
  s.summary      = "Lotusoot"

  s.homepage     = "https://github.com/summertian4/Lotusoot"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "周凌宇" => "coderfish@qq.com" }
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/summertian4/Lotusoot.git", :tag => s.version.to_s }

  s.source_files  = "Lotusoot/*"

end
