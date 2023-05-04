Pod::Spec.new do |s|

  s.name         = 'BsMachOKit'
  s.version      = '1.0.0'
  s.summary      = '对 Mach-O 特定 Segment 和 Section 的数据读写'
  s.homepage     = 'https://github.com/BaldStudio'
  s.license      = { :type => 'MIT', :text => 'LICENSE' }
  s.author       = { 'crzorz' => 'crzorz@outlook.com' }
  s.source       = { :git => 'https://github.com/BaldStudio/BsMachOKit.git', :tag => s.version.to_s }

  s.static_framework = true

  s.ios.deployment_target = "9.0"
  s.ios.source_files = 'BsMachOKit/Sources/**/*'

end
