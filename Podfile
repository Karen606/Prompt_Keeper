# Uncomment the next line to define a global platform for your project
# platform :ios, '15.0'

target 'Prompt_Keeper' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Prompt_Keeper
  pod 'FirebaseAnalytics'
  pod 'Firebase/RemoteConfig'
  pod 'DropDown'
  pod 'TTSwitch', '~> 0.0.5'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
end
