Pod::Spec.new do |s|

  s.name         = "test"
  s.version      = "1.1.0"
  s.summary      = "test"
  s.homepage     = "https://github.com/yudi40060/test"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "yudi" => "547429244@qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/yudi40060/test.git", :tag => s.version }
  s.source_files  = "test/**/*.{h,m,a,db,swift}"
# s.framework    = 'AlipaySDK'
#  s.resources    = "test/**/*.{bundle,png,xib}"

   s.vendored_library = 'libSocialQQ.a','libUMSocial_Sdk_4.2.a','libUPPayPlugin.a','libWeChatSDK.a','libappsearch.a','libSocialSina.a','libUMSocial_Sdk_Comment_4.2.a','libSocialWechat.a','libMobClickLibrary.a','libPods-ddd.a','TencentOpenAPI.framework'
  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"
  s.requires_arc = true
  s.pod_target_xcconfig = { 'ENABLE_BITCODE' => 'NO' }

end
