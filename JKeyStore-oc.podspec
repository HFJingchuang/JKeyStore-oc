Pod::Spec.new do |s|
  s.name         = "JKeyStore-oc"
  s.version      = "1.0.1"
  s.summary      = "JKeyStore-oc to be used for interacting with jingtum blockchain network。This is the objective-c version。"
  s.description  = "jJKeyStore-oc to be used for interacting with jingtum blockchain network。This is the objective-c version。"
  s.homepage     = "https://github.com/HFJingchuang/JKeyStore-oc"
  s.license= { :type => "MIT", :file => "LICENSE" }
  s.author       = { "PointZ" => "zhoudiancheng0803@qq.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/HFJingchuang/JKeyStore-oc.git", :tag => "#{s.version}" }
  s.source_files = "WebSocketClient/*.{h,m}","WebSocketClient/jingtum-lib/*.{h,m}", "WebSocketClient/WebSocket/*.{h,m}"
  s.ios.deployment_target = '10.0'
  s.frameworks   = 'UIKit'
  s.requires_arc = true
  s.dependency 'JSONModel'
  s.dependency 'NAChloride'
  s.dependency 'CoreBitcoin'
  s.dependency 'OpenSSL-Universal', '1.0.1.16'
  s.dependency 'ISO8601DateFormatter'
  s.dependency 'SocketRocket'
  s.dependency 'ZXingObjC' , '~> 3.6.4'
end
