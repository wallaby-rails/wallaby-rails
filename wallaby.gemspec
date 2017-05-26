# -*- encoding: utf-8 -*-

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

app_name = 'wallaby'
# Maintain your gem's version:
require "#{app_name}/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = app_name
  s.version = Wallaby::VERSION
  s.authors = ['Tianwen Chen']
  s.email = ['me@tian.im']
  s.homepage = "https://github.com/reinteractive/#{app_name}"
  s.summary = 'Rails way database admin interface'
  s.description = s.summary
  s.license = 'MIT'

  s.files = Dir[
    '{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc'
  ]
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 5.0'
  s.add_dependency 'devise', '>= 4.0'
  s.add_dependency 'kaminari'
  s.add_dependency 'cancancan'
  s.add_dependency 'parslet'

  s.add_dependency 'sprockets-rails'
  s.add_dependency 'sass-rails'

  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'bootstrap3-datetimepicker-rails'
  s.add_dependency 'codemirror-rails'
  s.add_dependency 'jquery-minicolors-rails'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'momentjs-rails'
  s.add_dependency 'rails-bootstrap-markdown'
  s.add_dependency 'summernote-rails'
end
