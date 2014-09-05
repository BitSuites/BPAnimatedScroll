Pod::Spec.new do |s|
  s.name         = "BPAnimatedScroll"
  s.version      = "0.0.1"
  s.summary      = "Anaimted Scroll view that can move objects in any direction"
  s.description  = "Anaimted Scroll view that can move objects in any direction given a start middle and end point"
  s.homepage     = "http://www.bitsuites.com"
  s.license      = 'MIT'
  s.authors      = { "Justin Carstens" => "justinc@bitsuites.com"}

  s.platform     = :ios, '6.0'
  s.source       = { :git => "git@github.com:BitSuites/BPAnimatedScroll.git"}

  s.source_files  = 'BPAnimatedScroll/*.{h,m}'

  s.requires_arc = true

end
