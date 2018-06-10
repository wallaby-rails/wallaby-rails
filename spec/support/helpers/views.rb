def field_name_from(file)
  file[/_(.+)\.[^\.]+\.erb_spec\.rb$/, 1]
end

def type_from(file)
  file[%r{/([^/]+)/_}, 1]
end
