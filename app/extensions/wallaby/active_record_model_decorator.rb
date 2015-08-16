module Wallaby
  class ActiveRecordModelDecorator < ModelDecorator
    def resources_name
      Wallaby::Utils.to_resources_name @model_class.name
    end

    def to_param
      resources_name
    end

    def to_s
      @model_class.model_name.human
    end
  end
end