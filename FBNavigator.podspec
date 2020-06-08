Pod::Spec.new do |spec|
  spec.name         = "FBNavigator"
  spec.version      = "0.0.1"
  spec.summary      = "A SOLID (at least wannabe) and simple implementation of navigation"
  spec.description = "A SOLID (at least wannabe) and simple implementation of navigation that you can use with enumeration of viewcontrollers to make the routes"

  spec.homepage     = "https://github.com/Felip38rito/FBNavigator"
  spec.license      = "MIT"
  spec.author             = { "Felip38rito" => "felipe.correia.wd@gmail.com" }
  spec.source       = { :git => "https://github.com/Felip38rito/FBNavigator.git", :tag => "#{spec.version}" }
  spec.source_files  = "FBNavigator/**/*.{h,m,swift}"
  spec.exclude_files = "Classes/Exclude"
end
