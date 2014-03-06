Pod::Spec.new do |s|
  s.name         = "oauthconsumer"
  s.version      = "0.0.1-cb"
  s.summary      = "An OAuth Consumer implementation in Objective-C"
  s.description  = <<-DESC
                      This is an iPhone ready version of:
                      http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/
                   DESC
  s.homepage     = "https://github.com/yyjim/oauthconsumer"
  s.license      = 'MIT'
  s.author       = "google", "jdg", "yyjim"
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/yyjim/oauthconsumer.git", :tag => "0.0.1-cb" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.source_files  = '**/*.{h,m,c}'
  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.framework = 'Security'
  s.libraries = 'xml2'
  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  s.requires_arc = false
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
end
