class Wallaby::ApplicationController < ActionController::Base
  rescue_from \
    Wallaby::ResourceNotFound,
    Wallaby::ModelNotFound,
    with: :not_found

  def not_found(exception = nil)
    @exception = exception || Wallaby::OperationNotFound.new(params[:action])
    render 'wallaby/errors/not_found', status: 404
  end

  def _prefixes
    @_prefixes ||= Wallaby::PrefixesBuilder.new(self).build
  end

  def lookup_context
    @_lookup_context ||= Wallaby::LookupContextWrapper.new super
  end
end
