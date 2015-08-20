class Wallaby::ResourcesConstraints
  def matches? request
    params  = request.env['action_dispatch.request.path_parameters']
    %r(\d) =~ params[:id]
  end
end