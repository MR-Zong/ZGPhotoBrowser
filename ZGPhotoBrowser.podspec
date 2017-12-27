#
#  Be sure to run `pod spec lint ZGPhotoBrowser.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ZGPhotoBrowser"
  s.version      = "1.0.0"
  s.summary      = "a browser for photos"

  s.description  = <<-DESC
			to browse photo conveniently
                   DESC

  s.homepage     = "https://github.com/MR-Zong"


  #s.license      = "MIT (example)"
  s.license      = { :type => "Apache License, Version 2.0", :file => "FILE_LICENSE" }


  s.author             = { "ZongGenXu" => "540682674@qq.com" }


   s.platform     = :ios, "7.0"




  s.source       = { :git => "https://github.com/MR-Zong/ZGPhotoBrowser.git", :tag => "#{s.version}" }



  s.source_files  = "ZGPhotoBrowser/ZGPhotoBrowser/ZGPhotoBrowser/**/*.{h,m}"
  #s.exclude_files = "Classes/Exclude"



  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

   s.frameworks = "UIKit"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

    s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
   s.dependency "SDWebImage"

end