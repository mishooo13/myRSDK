Pod::Spec.new do |s|

  s.name                = "myRSDK"
  s.version             = "1.0"
  s.summary             = "MyRes Framework"
  s.description         = "MyRes Framework best delivery."
  s.homepage            = "http://raywenderlich.com"
  s.license             = "MIT"
  s.authors             = { "mishoo13" => "mohamed@otherlogic.com" }
  s.platform            = :ios, "12.0"
  s.source       	= { :git => "https://github.com/mishooo13/myRSDK.git", :tag => "1.0.0" }
  s.source_files        = "myRSDK"
  s.swift_version       = "5.0"

end