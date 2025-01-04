Pod::Spec.new do |s|
    s.name             = 'dr_media_picker'
    s.version          = '0.0.1'
    s.summary          = 'A Flutter plugin for picking media.'
    s.description      = <<-DESC
                         A Flutter plugin that allows you to pick photos, videos, and files.
                         DESC
    s.homepage         = 'https://morecambodia.com'
    s.license          = { :type => 'MIT', :file => '../LICENSE' }
    s.author           = { 'Darith' => 'darithkuch@outlook.com' }
    s.source           = { :path => '.' }
    s.source_files     = 'Classes/**/*'
    s.public_header_files = 'Classes/**/*.h'
    s.ios.deployment_target = '12.0'
    s.dependency 'Flutter'
  end
  