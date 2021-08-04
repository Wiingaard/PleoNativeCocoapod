Pod::Spec.new do |s|
    s.name             = 'PleoNative'
    s.version          = '0.0.5'
    s.summary          = 'A short description of this package.'
    s.homepage         = 'https://github.com/Wiingaard/PleoNativeCocoapod'
    s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
    s.author           = { 'Pleo' => 'martin.wiingaard@pleo.io' }
    s.source           = { :git => 'https://github.com/Wiingaard/PleoNativeCocoapod.git', :tag => s.version.to_s }
    s.ios.deployment_target = '13.0'
    s.swift_version = '5.0'
    s.resources = 'PleoMobileRN/output'
  end

