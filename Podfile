source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :ios, '9.0'

project 'SortonsEvents'

def common_pods
    pod 'ObjectMapper', :git => 'https://github.com/Hearst-DD/ObjectMapper.git'
    pod 'Alamofire',   :git => 'https://github.com/Alamofire/Alamofire.git'
    pod 'AlamofireImage', :git => 'https://github.com/Alamofire/AlamofireImage.git'
    pod 'Fabric'
    pod 'Crashlytics'
    
end

target 'FOMO DCU' do
    common_pods
end
target 'FOMO DIT' do
    common_pods
end
target 'FOMO NUIG' do
    common_pods
end
target 'FOMO NUIM' do
    common_pods
end

target 'FOMO QUB' do
    common_pods
end

target 'FOMO TCD' do
    common_pods
end

target 'FOMO UCC' do
    common_pods
end

target 'FOMO UCD' do
    common_pods
end

target 'FOMO UL' do
    common_pods
end

# Figure out which are really needed in the test classes – get @import testable working
target 'SortonsEventsTests' do
    common_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
