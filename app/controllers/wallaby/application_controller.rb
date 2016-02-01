class Wallaby::ApplicationController < ::Wallaby.configuration.base_controller
  rescue_from \
    Wallaby::ResourceNotFound,
    Wallaby::ModelNotFound,
    with: :not_found

  def not_found(exception = nil)
    @exception = exception || Wallaby::OperationNotFound.new(params[:action])
    render 'wallaby/errors/not_found', status: 404
  end

  def _prefixes
    @_prefixes ||= begin
      if respond_to? :resources_name
        # NOTE: this is to override the origin prefix and speed up things
        # we only need two prefixes
        resource_prefix = resources_name.gsub '::', '/'
        [ resource_prefix, 'wallaby/resources' ]
      else
        super
      end
    end
  end

  def lookup_context
    @_lookup_context ||= Wallaby::LookupContextWrapper.new super
  end
end
