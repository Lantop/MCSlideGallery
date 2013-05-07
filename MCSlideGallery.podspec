Pod::Spec.new do |s|
  s.name     = 'MCSlideGallery'
  s.version  = '0.5.0'
  s.summary  = 'Slide gallery in Mobile Campus'
  s.homepage = 'https://github.com/lantop/MCSlideGallery'
  s.authors  = { 'Lanvige Jiang' => 'lanvige@gmail.me' }
  s.source   = { :git => 'https://github.com/Lantop/MCSlideGallery' }
  s.source_files = 'MCSlideGallery'
  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  
  # The readme says that it is needed but it lints without
end