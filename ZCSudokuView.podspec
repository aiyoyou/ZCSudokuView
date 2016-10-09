#
#  Be sure to run `pod spec lint ZCSudokuView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "ZCSudokuView"
  s.version      = "0.0.1"
  s.summary      = "An sudoku view on iOS."
  s.description  = <<-DESC
九宫格控件，支持之定义九宫格样式。
                   DESC
  s.homepage     = "https://github.com/aiyoyou/ZCSudokuView"
  s.license      = "MIT"
  s.author             = { "aiyoyou" => "3468919648@qq.com" }
  s.source       = { :git => "https://github.com/aiyoyou/ZCSudokuView.git", :tag => "#{s.version}" }
  s.source_files  = "ZCSudokuView", "ZCSudokuView/**/*.{h,m}"
  s.exclude_files = "ZCSudokuView/**/*.h"
  s.framework    = "UIKit"
end
