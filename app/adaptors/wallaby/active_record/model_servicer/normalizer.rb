class Wallaby::ActiveRecord::ModelServicer::Normalizer
  def initialize(model_decorator)
    @model_decorator = model_decorator
  end

  def normalize(params)
    params.each do |field_name, values|
      next unless metadata = @model_decorator.fields[field_name]

      case metadata[:type]
      when /range/
        normalize_range_values params, field_name, values
      when /point/
        normalize_point_values params, field_name, values
      when /binary/
        normalize_binary_values params, field_name, values
      end
    end
  end

  def normalize_range_values(params, field_name, values)
    normalized = Array(values).map(&:presence).compact
    if normalized.length > 0 && values.length == 2
      params[field_name] = values.first...values.last
    else
      params[field_name] = nil
    end
  end

  def normalize_point_values(params, field_name, values)
    normalized = Array(values).map(&:presence).compact
    if normalized.length > 0
      params[field_name] = values.map &:to_f
    else
      params[field_name] = nil
    end
  end

  def normalize_binary_values(params, field_name, values)
    if values.is_a?(ActionDispatch::Http::UploadedFile)
      params[field_name] = values.read
    end
  end
end
