Pod::Spec.new do |s|
    s.name             = 'PleoNative'
    s.version          = '0.1.0'
    s.summary          = 'A short description of this package.'
    s.homepage         = 'https://github.com/quickbirdstudios/BloggerBird'
    s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
    s.author           = { 'Pleo' => 'martin.wiingaard@pleo.io' }
    s.source           = { :git => 'https://github.com/quickbirdstudios/BloggerBird.git'}
    s.ios.deployment_target = '13.0'
    s.swift_version = '5.0'
    s.source_files = 'Sources/BloggerBird/**/*'
  end
