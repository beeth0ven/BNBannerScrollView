Pod::Spec.new do |s|
    s.name = "BNBannerScrollView"
    s.version = "3.0.3"
    s.license = { :type => "MIT", :file => "LICENSE" }
    s.summary = "BNBannerScrollView"
    s.homepage = "https://github.com/beeth0ven/BNBannerScrollView"
    s.author = { "Luo Jie" => "beeth0vendev@gmail.com" }
    s.source = { :git => "https://github.com/beeth0ven/BNBannerScrollView.git", :tag => "#{s.version}"}

    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.requires_arc = true

    s.source_files = "BNBannerScrollView/*.swift"
    s.resources = "BNBannerScrollView/*.{storyboard}"

    s.dependency 'SDWebImage', '~>3.8.0'
end
