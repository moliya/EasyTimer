Pod::Spec.new do |s|

  s.name          = "KFEasyTimer"
  s.version       = "1.3.0"
  s.summary       = "轻量级的倒计时触发器"
  s.homepage      = "https://github.com/moliya/EasyTimer"
  s.license       = "MIT"
  s.author        = {'Carefree' => '946715806@qq.com'}
  s.source        = { :git => "https://github.com/moliya/EasyTimer.git", :tag => s.version}
  s.source_files  = "Sources/*"
  s.requires_arc  = true
  s.platform      = :ios, '9.0'
  s.swift_version = '5.0'

end
