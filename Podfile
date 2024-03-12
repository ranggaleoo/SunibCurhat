# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'SunibCurhat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SunibCurhat
  pod 'Kingfisher'
  pod 'Siren'
  pod 'IQKeyboardManagerSwift'
  pod 'SPPermissions'
  pod 'SPPermissions/Notification'
  pod 'SPPermissions/Camera'
  pod 'SPPermissions/PhotoLibrary'
  pod 'SPPermissions/Contacts'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'TransitionButton'
  pod 'Socket.IO-Client-Swift'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
