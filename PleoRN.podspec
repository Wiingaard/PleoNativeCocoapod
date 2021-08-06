#
# Be sure to run `pod lib lint PleoRN.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

require 'json'

# Returns the version number for a package.json file
pkg_version = lambda do |dir_from_root = '', version = 'version'|
  path = File.join(__dir__, dir_from_root, 'package.json')
  JSON.parse(File.read(path))[version]
end

# Let the main package.json decide the version number for the pod
pleo_rn_version = pkg_version.call
# Use the same RN version that the JS tools use
react_native_version = pkg_version.call('node_modules/react-native')

Pod::Spec.new do |s|
  s.name             = 'PleoRN'
  s.version          = pleo_rn_version
  s.description      = 'Components for PleoRn.'
  s.summary          = 'Components for PleoRn.'
  s.homepage         = 'https://github.com/Wiingaard/PleoNativeCocoapod'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'Martin' => 'martin.wiingaard@pleo.io' }
  s.source           = { git: 'https://github.com/Wiingaard/PleoNativeCocoapod.git', tag: s.version.to_s }

  s.source_files   = 'Pod/Classes/**/*.{h,m,swift}'
  s.resources      = 'Pod/Assets/{PleoRN.js,assets}'
  s.platform       = :ios, '13.0'

  # React is split into a set of subspecs, these are the essentials
  s.dependency 'React/Core', react_native_version
  s.dependency "React-Core/DevSupport", react_native_version
  s.dependency "React-Core/RCTWebSocket", react_native_version
  s.dependency "React-RCTActionSheet", react_native_version
  s.dependency "React-RCTAnimation", react_native_version
  s.dependency "React-RCTBlob", react_native_version
  s.dependency "React-RCTImage", react_native_version
  s.dependency "React-RCTLinking", react_native_version
  s.dependency "React-RCTNetwork", react_native_version
  s.dependency "React-RCTSettings", react_native_version
  s.dependency "React-RCTText", react_native_version
  s.dependency "React-RCTVibration", react_native_version

  # React's dependencies
  podspecs = [
    'node_modules/react-native/ReactCommon/yoga/Yoga.podspec',
    'node_modules/react-native/third-party-podspecs/DoubleConversion.podspec',
    'node_modules/react-native/third-party-podspecs/Folly.podspec',
    'node_modules/react-native/third-party-podspecs/glog.podspec'
  ]
  podspecs.each do |podspec_path|
    spec = Pod::Specification.from_file podspec_path
    s.dependency spec.name, "#{spec.version}"
  end
end
