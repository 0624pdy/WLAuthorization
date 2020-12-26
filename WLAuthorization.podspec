#
# Be sure to run `pod lib lint WLAuthorization.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                = 'WLAuthorization'
  s.version             = '0.0.1'
  s.summary             = 'iOS权限管理工具'
  s.description         = <<-DESC
  iOS权限管理工具，包括但不限于：
  相册、相机、通讯录、麦克风、蓝牙、通知、定位 ......
                       DESC

  s.homepage            = 'https://github.com/0624pdy/WLAuthorization'
  s.license             = { :type => 'MIT', :file => 'LICENSE' }
  s.author              = {
                            '0624pdy' => '0624pdy@sina.com',
                            '0530pdy' => 'pengduanyang@jze100.com',
                            '0711pdy' => '857466752@qq.com'
                          }
  s.source              = { :git => 'https://github.com/0624pdy/WLAuthorization.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files        = 'WLAuthorization/Classes/**/*'
  s.frameworks          = 'UIKit', 'Foundation', 'CoreGraphics', 'Contacts', 'AVFoundation', 'AssetsLibrary', 'Photos', 'CoreTelephony'
  
  # s.resource_bundles = {
  #   'WLAuthorization' => ['WLAuthorization/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  
  
  
  s.subspec 'Base' do |base|
      base.source_files = 'WLAuthorization/Classes/Base/*'
  end
  
  
  s.subspec 'Location' do |location|
      location.frameworks   = 'CoreLocation'
      location.dependency 'WLAuthorization/Base'
      location.source_files = 'WLAuthorization/Classes/Location/*'
  end
  
end
