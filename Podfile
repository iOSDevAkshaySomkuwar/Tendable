# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

target 'Tendable' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Alamofire'
  pod 'SnapKit'
  pod 'IQKeyboardManagerSwift'

  # Pods for Tendable

  target 'TendableTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TendableUITests' do
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          end
      end
  end

end
