source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :ios, '9.0'

xcodeproj 'SortonsEvents'

pod 'Alamofire', '~> 3.4'

target 'FOMO UCD' do
    pod 'ObjectMapper'
    pod 'Alamofire', '~> 3.4'
    pod 'AlamofireImage', '~> 2.0'
end

# Figure out which are really needed in the test classes – get @import testable working
target 'SortonsEventsTests' do
    pod 'Alamofire', '~> 3.4'
    pod 'ObjectMapper'
    
    pod 'AlamofireImage', '~> 2.0'
end


# Objective C pods to be removed:

pod 'AFNetworking'
pod 'SDWebImage'

#pod 'FBSDKCoreKit'
#pod 'FBSDKLoginKit'
#pod 'FBSDKShareKit'
