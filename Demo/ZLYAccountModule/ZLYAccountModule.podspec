#
#  Be sure to run `pod spec lint LPDBPublicModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "ZLYAccountModule"
  s.version      = "0.0.1"
  s.summary      = "账户模块"
  s.license      = { :type => "GPL", :file => "LICENSE" }

  s.homepage     = "https://github.com/Vegetarians/Lotusoot"
  s.source       = { :git => "https://github.com/summertian4/ZLYAccountModule.git", :tag => "#{s.version}" }
  s.source_files = "Source/**/*"
  s.requires_arc = true
  s.platform     = :ios, "8.0"

  s.dependency   'ZLYPublicModule', '~> 0.0.1'
  
  # User
  s.author             = { "小鱼周凌宇" => "coderfish@163.com" }
  s.social_media_url   = "http://zhoulingyu.com"

end