Pod::Spec.new do |s|

  s.name              = 'AnyDate'
  s.version           = '1.0.6'
  s.summary           = 'Swifty Date & Time API inspired from Java 8 DateTime API.'
  s.license           = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage          = 'https://github.com/kawoou/AnyDate'
  s.authors           = { 'Jungwon An' => 'kawoou@kawoou.kr' }
  s.social_media_url  = 'http://fb.com/kawoou'
  s.source            = { :git => 'https://github.com/Kawoou/AnyDate.git', :tag => 'v' + s.version.to_s }

  s.source_files      = 'Sources/**/*.{swift}'
  s.frameworks        = 'Foundation'
  s.module_name       = 'AnyDate'
  s.requires_arc      = true

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.watchos.deployment_target = '2.0'

end
