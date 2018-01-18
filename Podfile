platform :ios, '9.0'
use_frameworks!

target 'PokeSpin' do
    pod 'Alamofire', '~> 4.5'
    pod 'ObjectMapper', '~> 2.2.9' #using Swift 3
    pod 'ObjectMapper_RealmSwift', '~> 0.1.0' #using Swift 3
    pod 'RealmSwift', '~> 2.3' #using Swift 4
    pod 'SnapKit', '~> 4.0.0' #using Swift 4
end

post_install do |installer|
    # Your list of targets here.
    myTargets = ['ObjectMapper', 'ObjectMapper_RealmSwift']

    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
