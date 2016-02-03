require 'securerandom'

module Wallaby::ResourcesHelper
  def type_partial_render(options = {}, locals = {}, &block)
    decorated   = locals[:object]
    field_name  = locals[:field_name].to_s

    fail ArgumentError unless field_name.present? && decorated.is_a?(Wallaby::ResourceDecorator)

    options   = "#{ action_name }/#{ options }" if options.is_a? String

    locals[:metadata] = decorated.metadata_of field_name
    locals[:value]    = decorated.send field_name

    render options, locals, &block or locals[:value]
  end

  def show_title(decorated)
    fail ArgumentError unless decorated.is_a? Wallaby::ResourceDecorator
    [ decorated.model_label, decorated.to_label ].compact.join ': '
  end
end
