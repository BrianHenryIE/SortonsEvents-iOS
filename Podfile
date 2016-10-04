source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :ios, '9.0'

project 'SortonsEvents'

target 'FOMO UCD' do
    pod 'ObjectMapper', '~> 2.0'
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.0'
end

# Figure out which are really needed in the test classes – get @import testable working
target 'SortonsEventsTests' do
    pod 'Alamofire', '~> 4.0'
    pod 'ObjectMapper', '~> 2.0'
    pod 'AlamofireImage', '~> 3.0'
end


# Objective C pods to be removed:

pod 'AFNetworking'
pod 'SDWebImage'

#pod 'FBSDKCoreKit'
#pod 'FBSDKLoginKit'
#pod 'FBSDKShareKit'


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
