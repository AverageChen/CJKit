
Pod::Spec.new do |s|

  s.name         = "CJKit"
  s.version      = "0.0.1"
  s.summary      = "A short description of CJKit."
  s.description  = <<-DESC
  this is my description
                   DESC
  s.platform     = :ios, "9.0"
  s.homepage     = "http://EXAMPLE/CJKit"
  s.license      = { :type => "MIT", :file => "LICENSE"}
  s.author       = { "Average" => "490620383@qq.com" }
  s.source       = { :git => "https://github.com/AverageChen/CJKit.git", :tag => s.version }
  s.source_files  = "CJFile", "CJKit/CJKit/CJFile/**/*.{h,m}"

end
