# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Wheather' do

  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Wheather
  pod 'SwiftLint'
  post_install do |pi|
   t = pi.pods_project.targets.find { |t| t.name == 'SwiftLint' }
   t.build_configurations.each do |bc|
     bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
  	 end
	end 

  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'Alamofire', '~> 5.2'
		
end
