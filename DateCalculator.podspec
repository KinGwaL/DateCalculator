

Pod::Spec.new do |s|

  s.name         = "DateCalculator"
  s.version      = "0.0.2"
  s.summary      = "Upload DateCalculator to github and trying cocoapods"
  s.description  = "DateCalculator provide easily way to help you create Date object"
  s.homepage     = "https://github.com/KinGwaL/DateCalculator"
  s.license      = "MIT"
  s.author       = { "KING" => "king_lai@outlook.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/KinGwaL/DateCalculator.git", :tag => "0.0.2" }
  s.source_files  = "DateCalculator", "DateCalculator.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

end
