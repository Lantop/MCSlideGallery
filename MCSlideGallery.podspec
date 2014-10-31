Pod::Spec.new do |s|
  s.name     = 'MCSlideGallery'
  s.version  = '0.6.1'
  s.summary  = 'Slide gallery in Mobile Campus'
  s.homepage = 'https://github.com/lantop/MCSlideGallery'
  s.authors  = { 'Lanvige Jiang' => 'lanvige@gmail.com' }
  s.source   = { :git => 'https://github.com/Lantop/MCSlideGallery' }
  s.source_files = 'MCSlideGallery'
  s.resources = 'MCSlideGallery/MCSlideGallery.bundle'
  s.requires_arc = true

  s.ios.deployment_target = '6.0'
  s.ios.frameworks = 'AVFoundation', 'MediaPlayer'

  # The readme says that it is needed but it lints without
end