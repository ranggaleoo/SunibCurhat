# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'SunibCurhat' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SunibCurhat
  pod 'FirebaseCore'
  pod 'FirebaseAnalytics'
  pod 'FirebaseCrashlytics'
  pod 'FirebaseMessaging'
  
  pod 'AgoraRtcEngine_iOS'
 
  pod 'Instructions'
  pod 'Kingfisher'
  pod 'Siren'
  pod 'IQKeyboardManagerSwift'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'TransitionButton'
  pod 'Socket.IO-Client-Swift'
  pod 'Cloudinary'
  pod 'SkeletonView'
  
  pod 'PermissionsKit/CameraPermission', :git => 'https://github.com/sparrowcode/PermissionsKit'
  pod 'PermissionsKit/PhotoLibraryPermission', :git => 'https://github.com/sparrowcode/PermissionsKit'
  pod 'PermissionsKit/NotificationPermission', :git => 'https://github.com/sparrowcode/PermissionsKit'
  pod 'PermissionsKit/MicrophonePermission', :git => 'https://github.com/sparrowcode/PermissionsKit'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
