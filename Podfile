project 'VerIDSampleApp.xcodeproj'
workspace 'VerIDSampleApp.xcworkspace'
platform :ios, '11'

target 'VerIDSampleApp' do
    use_frameworks!
    pod 'Ver-ID', :git => 'https://github.com/AppliedRecognition/Ver-ID-UI-iOS.git', :tag => 'v2.4.0e01'
    post_install do |installer|
        installer.pods_project.build_configurations.each do |config|
            config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        end
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings.delete 'BUILD_LIBRARY_FOR_DISTRIBUTION'
            end
        end
    end
end
