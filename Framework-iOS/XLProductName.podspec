Pod::Spec.new do |s|
  s.name             = "XLProductName"
  s.version          = "1.0.0"
  s.summary          = "A short description of XLProductName."
  s.homepage         = "https://github.com/XLUserName/XLProductName"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "XLAuthorName" => "XLAuthorEmail" }
  s.source           = { git: "https://github.com/XLUserName/XLProductName.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/XLUserName'
  s.ios.deployment_target = '13.0'
  s.requires_arc = true
  s.ios.source_files = 'XLProductName/Sources/**/*.{swift}'
  # s.resource_bundles = {
  #   'XLProductName' => ['XLProductName/Sources/**/*.xib']
  # }
  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'Eureka', '~> 4.0'
end
