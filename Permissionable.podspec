Pod::Spec.new do |s|
  s.name             = "Permissionable"
  s.version          = "0.4"
  s.summary          = "A simplified Swifty way of asking users for permissions on iOS, based on Cluster's Pre-Permissions."

  s.description      = <<-DESC
A simplified Swifty way of asking users for permissions on iOS, inpired by Cluster's Pre-Permissions: https://github.com/clusterinc/ClusterPrePermissions
                       DESC

  s.homepage         = "https://github.com/BellAppLab/Permissionable"
  s.license          = 'MIT'
  s.author           = { "Bell App Lab" => "apps@bellapplab.com" }
  s.source           = { :git => "https://github.com/BellAppLab/Permissionable.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/BellAppLab'

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.frameworks = 'UIKit'

  s.default_subspec = 'All'

  s.subspec 'Core' do |sp|
    sp.dependency 'Alertable'
    sp.dependency 'Defines'
    sp.source_files = 'Pod/Classes/*.{swift}'
  end

  s.subspec 'Camera' do |sp|
    sp.dependency 'Permissionable/Core'
    sp.frameworks = 'AVFoundation'
    sp.source_files = 'Pod/Classes/Camera/*.{swift}'
  end

  s.subspec 'Photos' do |sp|
    sp.dependency 'Permissionable/Core'
    sp.frameworks = 'Photos'
    sp.source_files = 'Pod/Classes/Photos/*.{swift}'
  end

  s.subspec 'All' do |sp|
    sp.dependency 'Permissionable/Core'
    sp.dependency 'Permissionable/Camera'
    sp.dependency 'Permissionable/Photos'
  end
end
