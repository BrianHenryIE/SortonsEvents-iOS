source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :ios, '9.0'

project 'SortonsEvents'

def all_pods
    pod 'ObjectMapper', '~> 2.2'
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.1'
end

target 'FOMO UCD' do
    all_pods
end

target 'FOMO TCD' do
    all_pods
end


# Figure out which are really needed in the test classes – get @import testable working
target 'SortonsEventsTests' do
    pod 'Alamofire', '~> 4.0'
    pod 'ObjectMapper', '~> 2.0'
    pod 'AlamofireImage', '~> 3.0'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
