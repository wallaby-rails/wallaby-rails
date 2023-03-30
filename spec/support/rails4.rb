# frozen_string_literal: true

if Rails::VERSION::MAJOR == 4
  def file_fixture(fixture_name)
    file_fixture_path = 'spec/fixtures/files'
    path = Pathname.new(File.join(file_fixture_path, fixture_name))

    if path.exist?
      path
    else
      msg = "the directory '%s' does not contain a file named '%s'"
      raise ArgumentError, format(msg, file_fixture_path, fixture_name)
    end
  end

  ActionView::TestCase::TestController.instance_eval do
    helper Rails.application.routes.url_helpers
  end

  ActionView::TestCase::TestController.class_eval do
    def _routes
      Rails.application.routes
    end
  end
end
