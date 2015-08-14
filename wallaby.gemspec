# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

namespace = 'wallaby'
# Maintain your gem's version:
require "#{ namespace }/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = namespace
  s.version     = Wallaby::VERSION
  s.authors     = [ 'Tianwen Chen' ]
  s.email       = [ 'me@tian.im' ]
  s.homepage    = "http://rubygems.org/gems/#{ namespace }"
  s.summary     = 'Rails way database administration'
  s.description = s.summary
  s.license     = 'MIT'

  s.files       = Dir[  '{app,config,db,lib}/**/*',
                        'MIT-LICENSE',
                        'Rakefile',
                        'README.rdoc' ]
  s.test_files  = Dir[ 'test/**/*' ]

  s.add_dependency 'rails', '~> 4.2.3'
  s.add_dependency 'sass-rails'
  s.add_dependency 'kaminari'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'sprockets-rails'
end
