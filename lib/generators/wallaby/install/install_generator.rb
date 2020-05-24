# frozen_string_literal: true

module Wallaby
  # `wallaby:install` generator
  class InstallGenerator < Rails::Generators::NamedBase
    argument :name, type: :string, default: 'admin'

    class_option \
      :mount_only,
      type: :boolean, default: false,
      aliases: :'-m',
      desc: 'Only mount Wallaby to given name.'

    class_option \
      :include_authorizer,
      aliases: :'-a',
      type: :boolean, default: false,
      desc: 'Include to generate application authorizer.'

    class_option \
      :include_paginator,
      aliases: :'-g',
      type: :boolean, default: false,
      desc: 'Include to generate application paginator.'

    class_option \
      :include_partials,
      aliases: :'-v',
      type: :boolean, default: false,
      desc: 'Include to generate application partials'

    # @see https://github.com/wallaby-rails/wallaby/blob/master/lib/generators/wallaby/install/USAGE
    def install
      invoke 'wallaby:engine:install', [name], options.dup
    end
  end
end
