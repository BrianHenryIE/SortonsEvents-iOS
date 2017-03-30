source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!
platform :ios, '9.0'

project 'SortonsEvents'

def common_pods
    pod 'Alamofire',   :git => 'https://github.com/Alamofire/Alamofire.git'
    pod 'AlamofireImage', :git => 'https://github.com/Alamofire/AlamofireImage.git'
    pod 'AlamofireObjectMapper', :git => 'https://github.com/tristanhimmelman/AlamofireObjectMapper'
    pod 'ObjectMapper', :git => 'https://github.com/Hearst-DD/ObjectMapper.git'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'ReachabilitySwift', '~> 3'
    pod 'DZNEmptyDataSet'
    # Mofified and added to project
    # pod 'SLPagingViewSwift-Swift3', :git => 'https://github.com/davidseek/SLPagingViewSwift-Swift-3-Tinder-Twitter.git'
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
    pod 'Mockingjay', :git => 'https://github.com/kylef/Mockingjay.git'
    # pod 'Quick', :git => 'https://github.com/Quick/Quick.git'
    # pod 'Nimble', :git => 'https://github.com/Quick/Nimble.git'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
