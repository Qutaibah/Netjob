#
# Be sure to run `pod lib lint Netjob.podspec' to ensure this is a
# valid spec before submitting.
#

Pod::Spec.new do |s|
  s.name = "Netjob"
  s.version = "0.1.0"
  s.license = "MIT"
  s.summary = "Elegant HTTP Networking in Swift"
  s.homepage = "https://github.com/Qutaibah/Netjob.git"
  s.authors = { "Alamofire Software Foundation" => "info@alamofire.org" }
  s.source = { :git => "https://github.com/Qutaibah/Netjob.git", :tag => s.version }
  # s.documentation_url = ""

  s.ios.deployment_target = "10.0"

  s.swift_versions = ["5"]

  s.source_files = "Netjob/*.swift"
end
