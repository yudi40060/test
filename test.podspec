Pod::Spec.new do |s|

  s.name         = "test"
  s.version      = "1.0.9"
  s.summary      = "test"
  s.homepage     = "https://github.com/yudi40060/test"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "yudi" => "547429244@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/yudi40060/test.git", :tag => "1.0.9" }
  s.source_files  = "test/**/*.{h,m,a,db,swift}"
# s.framework    = 'AlipaySDK'
#  s.resources    = "test/**/*.{bundle,png,xib}"

  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"
  s.requires_arc = true

end
