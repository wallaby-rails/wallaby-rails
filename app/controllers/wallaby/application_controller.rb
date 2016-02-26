class Wallaby::ApplicationController < ::Wallaby.configuration.base_controller
  rescue_from \
    Wallaby::ResourceNotFound,
    Wallaby::ModelNotFound,
    with: :not_found

  def not_found(exception = nil)
    @exception = exception || Wallaby::OperationNotFound.new(params[:action])
    render 'wallaby/errors/not_found', status: 404
  end
end
