class AllPostgresTypeDecorator < Wallaby::ResourceDecorator
  # self.fields[:color][:type] = 'color'
  # self.fields[:email][:type] = 'email'
  # self.fields[:password][:type] = 'password'

  self.filters[:true] = {
    scope: -> { where(boolean: true) }
  }
end
