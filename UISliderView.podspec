# coding: utf-8
Pod::Spec.new do |s|
    s.name = "UISliderView"
    s.version = "1.0.1"
    s.summary = "Easy and customizable Swift image slider with lazy loading images and full screen viewer"
    s.authors = { 'Aleksey Pleshkov' => 'im@alekseypleshkov.ru' }
    s.homepage = "https://github.com/AlekseyPleshkov/UISliderView"
    s.license= 'MIT'
    s.source = { :git => 'https://github.com/AlekseyPleshkov/UISliderView.git', :branch => "master", :tag => s.version.to_s }
    s.platform = :ios, '11.0'
    s.source_files = 'UISliderView/*.{h,m,swift}'
    s.requires_arc = true
    s.frameworks = 'UIKit'
    s.swift_version= "5.0"
end
