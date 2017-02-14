

Pod::Spec.new do |s|

  s.name         = "TAFNetworking"
  s.version      = "0.0.1"
  s.summary      = "TAFNetworking."

  s.description  = <<-DESC
  description of TAFNetworking.
                   DESC

  s.homepage     = "https://github.com/HeiHuaBaiHua/TAFNetworking"
  s.author             = "HeiHuaBaiHua" 
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/HeiHuaBaiHua/TAFNetworking.git", :tag => "#{s.version}" }

  s.source_files  = "TAFNetworking", "TAFNetworking/**/*.{h,m}"

  s.requires_arc = true

  s.dependency "AFNetworking", "~> 3.1.0"

end
